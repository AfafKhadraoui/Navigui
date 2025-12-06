# Security & Validation Guide

## SQL Injection Prevention Strategy

### 🎯 Two-Layer Defense

#### 1. **Frontend Validation (Flutter)** - User Experience Layer
Located in form validators like `step2Employer.dart`

**Purpose:**
- Provide immediate feedback to users
- Block obviously malicious input before it reaches the server
- Improve UX by catching errors early

**What we validate:**
- SQL keywords: `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `DROP`, `UNION`, etc.
- SQL comment patterns: `--`, `/*`, `*/`, `;`
- Injection patterns: `OR 1=1`, `AND 1=1`
- Script tags: `<script>`, `<iframe>`, `javascript:`, `onerror=`
- Invalid characters: `<>{}[]\`
- Length limits and format requirements

**Example from `_containsSQLInjection()` method:**
```dart
bool _containsSQLInjection(String input) {
  final sqlPatterns = [
    r"('|(\-\-)|;|(\/\*)|(\\*\/))",  // SQL comment patterns
    r'(\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|EXECUTE|UNION|SCRIPT)\b)',  // SQL keywords
    r"(\bOR\b.*=.*)",  // OR 1=1 patterns
    r"(\bAND\b.*=.*)",  // AND 1=1 patterns
  ];
  
  for (var pattern in sqlPatterns) {
    if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
      return true;
    }
  }
  return false;
}
```

#### 2. **Backend Validation (Flask + SQLAlchemy)** - CRITICAL SECURITY LAYER

⚠️ **NEVER trust frontend validation alone!** Users can bypass frontend checks.

##### ✅ **ALWAYS use Parameterized Queries with SQLAlchemy**

**WRONG (Vulnerable to SQL Injection):**
```python
# ❌ NEVER DO THIS
query = f"SELECT * FROM users WHERE email = '{email}'"
result = db.session.execute(query)
```

**CORRECT (Safe with parameterization):**
```python
# ✅ SQLAlchemy ORM (Automatic parameterization)
user = User.query.filter_by(email=email).first()

# ✅ SQLAlchemy Core with explicit binding
from sqlalchemy import text
query = text("SELECT * FROM users WHERE email = :email")
result = db.session.execute(query, {"email": email})
```

**Why this works:**
- Database treats parameters as DATA, not as SQL CODE
- Special characters are automatically escaped
- SQL structure cannot be modified by user input

---

## Field-Specific Validation

### 📱 Phone Number
```dart
String? _validatePhone(String? value) {
  // Remove formatting characters
  String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  
  // Check SQL injection
  if (_containsSQLInjection(value)) return 'Invalid characters detected';
  
  // Algerian format: +213 or 0 followed by 9 digits
  if (!RegExp(r'^(\+213|0)[5-7][0-9]{8}$').hasMatch(cleanPhone)) {
    return 'Invalid phone format';
  }
  
  return null;
}
```

**Accepts:**
- `+213 555 123 456`
- `0555123456`
- `+213555123456`

**Rejects:**
- SQL injection attempts
- Invalid Algerian numbers
- Non-numeric characters (except spaces, hyphens, parentheses for formatting)

### 📍 Location
```dart
String? _validateLocation(String? value) {
  // SQL injection check
  if (_containsSQLInjection(value)) return 'Invalid characters detected';
  
  // Block dangerous special characters
  if (RegExp(r'[<>{}\[\]\\]').hasMatch(value)) return 'Invalid characters';
  
  // Length validation
  if (value.trim().length < 3) return 'Location must be at least 3 characters';
  if (value.length > 100) return 'Location is too long (max 100 characters)';
  
  return null;
}
```

**Accepts:**
- `Algiers, Algeria`
- `New York, USA`
- `São Paulo, Brazil`

**Rejects:**
- SQL injection attempts
- Script tags or dangerous HTML
- Too short/long inputs

### 👤 Name (Business/Individual)
```dart
String? _validateName(String? value) {
  // SQL injection check
  if (_containsSQLInjection(value)) return 'Invalid characters detected';
  
  // Allow: letters, numbers, spaces, dots, apostrophes, hyphens, ampersands
  if (!RegExp(r"^[a-zA-Z0-9\s.,'&\-]+$").hasMatch(value)) {
    return 'Name contains invalid characters';
  }
  
  // Length validation
  if (value.trim().length < 2) return 'Name must be at least 2 characters';
  if (value.length > 100) return 'Name is too long (max 100 characters)';
  
  // No excessive consecutive special characters
  if (RegExp(r'[.\-&\s]{3,}').hasMatch(value)) {
    return 'Too many consecutive special characters';
  }
  
  return null;
}
```

**Accepts:**
- `John Doe`
- `Company Inc.`
- `O'Brien & Associates`
- `Tech Solutions 2024`

**Rejects:**
- SQL injection attempts
- Excessive special characters (e.g., `Name---...`)
- Invalid characters like `<>{}[]`

### 📝 Description
```dart
String? _validateDescription(String? value) {
  // Optional field - null is OK
  if (value == null || value.isEmpty) return null;
  
  // SQL injection check
  if (_containsSQLInjection(value)) return 'Invalid characters detected';
  
  // Block script tags and XSS attempts
  if (RegExp(r'<script|<iframe|javascript:|onerror=|onclick=', 
      caseSensitive: false).hasMatch(value)) {
    return 'Description contains forbidden content';
  }
  
  // Length validation
  if (value.trim().length < 10) return 'Description should be at least 10 characters';
  if (value.length > 500) return 'Description is too long (max 500 characters)';
  
  return null;
}
```

**Accepts:**
- Normal text descriptions
- Punctuation, emojis, line breaks
- International characters

**Rejects:**
- SQL injection attempts
- XSS attempts (`<script>`, `javascript:`, etc.)
- Too short/long text

---

## Backend Implementation (Flask + SQLAlchemy)

### Example: User Registration Endpoint

```python
from flask import Blueprint, request, jsonify
from sqlalchemy import text
from app.models import User, EmployerProfile
from app import db
import re

auth_bp = Blueprint('auth', __name__)

def validate_input_backend(data):
    """
    Backend validation - NEVER trust frontend!
    """
    errors = {}
    
    # Email validation
    if not re.match(r'^[^@]+@[^@]+\.[^@]+$', data.get('email', '')):
        errors['email'] = 'Invalid email format'
    
    # Phone validation
    phone = data.get('phone', '').replace(' ', '').replace('-', '')
    if not re.match(r'^(\+213|0)[5-7][0-9]{8}$', phone):
        errors['phone'] = 'Invalid phone format'
    
    # Name validation
    name = data.get('name', '')
    if not re.match(r"^[a-zA-Z0-9\s.,'&\-]+$", name):
        errors['name'] = 'Name contains invalid characters'
    
    if len(name) < 2 or len(name) > 100:
        errors['name'] = 'Name must be 2-100 characters'
    
    return errors

@auth_bp.route('/api/auth/register-employer', methods=['POST'])
def register_employer():
    data = request.get_json()
    
    # Backend validation
    validation_errors = validate_input_backend(data)
    if validation_errors:
        return jsonify({'errors': validation_errors}), 400
    
    # Check if user exists (using parameterized query)
    existing_user = User.query.filter_by(email=data['email']).first()
    if existing_user:
        return jsonify({'error': 'Email already registered'}), 409
    
    # Create user (SQLAlchemy ORM automatically parameterizes)
    new_user = User(
        email=data['email'],
        password_hash=generate_password_hash(data['password']),
        role='employer'
    )
    db.session.add(new_user)
    db.session.flush()  # Get user ID
    
    # Create employer profile
    employer_profile = EmployerProfile(
        user_id=new_user.id,
        phone=data['phone'],
        location=data['location'],
        name=data['name'],
        type=data['type'],
        description=data.get('description')  # Optional
    )
    db.session.add(employer_profile)
    db.session.commit()
    
    return jsonify({
        'message': 'Registration successful',
        'user_id': new_user.id
    }), 201
```

### Key Backend Security Practices

1. **Always validate on the backend** - frontend can be bypassed
2. **Use SQLAlchemy ORM or parameterized queries** - never concatenate SQL
3. **Hash passwords** - use `werkzeug.security.generate_password_hash()`
4. **Implement rate limiting** - prevent brute force attacks
5. **Use HTTPS** - encrypt data in transit
6. **Sanitize output** - prevent XSS when displaying user data
7. **Use prepared statements** even for raw SQL:

```python
# If you must use raw SQL
from sqlalchemy import text

query = text("""
    INSERT INTO employer_profiles (user_id, phone, location, name, type, description)
    VALUES (:user_id, :phone, :location, :name, :type, :description)
""")

db.session.execute(query, {
    'user_id': user_id,
    'phone': phone,
    'location': location,
    'name': name,
    'type': type_value,
    'description': description
})
db.session.commit()
```

---

## Additional Security Measures

### 1. Input Sanitization Library (Backend)
```python
import bleach

def sanitize_html(text):
    """Remove all HTML tags and scripts"""
    return bleach.clean(text, tags=[], strip=True)

description = sanitize_html(data.get('description', ''))
```

### 2. Rate Limiting (Flask-Limiter)
```python
from flask_limiter import Limiter

limiter = Limiter(
    app,
    key_func=lambda: request.remote_addr,
    default_limits=["200 per day", "50 per hour"]
)

@auth_bp.route('/api/auth/login', methods=['POST'])
@limiter.limit("5 per minute")  # Prevent brute force
def login():
    # ... login logic
```

### 3. CSRF Protection
```python
from flask_wtf.csrf import CSRFProtect

csrf = CSRFProtect(app)
```

### 4. Content Security Policy Headers
```python
@app.after_request
def set_security_headers(response):
    response.headers['Content-Security-Policy'] = "default-src 'self'"
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    return response
```

---

## Testing Your Validation

### Test Cases for SQL Injection

Try these inputs in your form (they should all be rejected):

```
Email: admin'--
Password: ' OR '1'='1
Name: Company'; DROP TABLE users; --
Description: <script>alert('XSS')</script>
Location: Paris'; DELETE FROM jobs WHERE '1'='1
```

All should show validation errors and never reach your database.

---

## Summary Checklist

✅ **Frontend (Flutter):**
- [ ] Form validators check for SQL patterns
- [ ] Length limits enforced
- [ ] Character restrictions applied
- [ ] User gets immediate feedback

✅ **Backend (Flask):**
- [ ] Re-validate ALL inputs (never trust frontend)
- [ ] Use SQLAlchemy ORM or parameterized queries
- [ ] Hash passwords with bcrypt/scrypt
- [ ] Implement rate limiting
- [ ] Add CSRF protection
- [ ] Use HTTPS in production
- [ ] Set security headers
- [ ] Log suspicious activity

✅ **Database:**
- [ ] Use least privilege principle (limited user permissions)
- [ ] Regular backups
- [ ] Monitor for suspicious queries

---

## Remember

> **The Golden Rule:** Frontend validation is for UX. Backend validation is for security. ALWAYS validate on both, but NEVER trust the frontend!

Parameterized queries make SQL injection **impossible** because user input is treated as data, not code.
