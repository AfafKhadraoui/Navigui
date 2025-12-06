// lib/data/databases/seed_data.dart
import 'package:sqflite/sqflite.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase(Database db) async {
    // Check if already seeded
    final articleCount =
        await db.rawQuery('SELECT COUNT(*) FROM education_articles');
    if (articleCount.first.values.first as int > 0) {
      print('Database already seeded');
      return;
    }

    print('Seeding database with dummy data...');

    final now = DateTime.now().toIso8601String();

    // Insert user accounts
    await db.insert('users', {
      'id': 'user123',
      'email': 'student@navigui.com',
      'password_hash': 'student123',
      'account_type': 'student',
      'name': 'Student User',
      'phone_number': '+213555123456',
      'location': 'Algiers, Algeria',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('users', {
      'id': 'user456',
      'email': 'employer@navigui.com',
      'password_hash': 'employer123',
      'account_type': 'employer',
      'name': 'Employer User',
      'phone_number': '+213555654321',
      'location': 'Oran, Algeria',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'student-1',
      'title': 'Your First Job: What to Expect',
      'content':
          '''Starting your first job can be both exciting and nerve-wracking. Here's what you need to know:

## Before You Start
- Review your employment contract carefully
- Prepare all necessary documents (ID, certificates)
- Plan your commute and arrival time

## First Day Tips
- Arrive 15 minutes early
- Dress professionally
- Bring a notebook and pen
- Be ready to learn and ask questions

## Common Mistakes to Avoid
- Don't be late or absent without notice
- Avoid gossiping or negative talk
- Don't use your phone excessively
- Never skip asking for clarification

## Building Good Relationships
- Be respectful to everyone
- Show initiative and willingness to help
- Communicate clearly and professionally
- Learn from feedback without taking it personally

Remember: Everyone was new once. Take your time to learn, and don't be afraid to ask for help!''',
      'category_id': 'career-tips',
      'target_audience': 'student',
      'image_url': 'assets/images/education/first-job.jpg',
      'author': 'Career Advisory Team',
      'read_time': 8,
      'views_count': 245,
      'likes_count': 89,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'student-2',
      'title': 'Writing a Winning Job Application',
      'content': '''Your application is your first impression. Make it count!

## Application Components
1. **Cover Letter**: Personalized introduction
2. **CV/Resume**: Your skills and experience
3. **References**: Professional contacts who can vouch for you

## Cover Letter Tips
- Address the hiring manager by name
- Explain why you want THIS specific job
- Highlight relevant skills and experiences
- Keep it concise (max 1 page)
- Proofread multiple times

## CV Best Practices
- Use a clean, professional format
- Start with contact information
- List education and work experience
- Include relevant skills and certifications
- Add any volunteer work or extracurricular activities

## Common Mistakes
- Generic applications (not tailored to the job)
- Spelling and grammar errors
- Including irrelevant information
- Using unprofessional email addresses
- Lying or exaggerating qualifications

## Follow-Up
- Send a thank you email after applying
- Be patient but proactive
- Keep track of applications submitted''',
      'category_id': 'application-tips',
      'target_audience': 'student',
      'image_url': 'assets/images/education/application-tips.jpg',
      'author': 'HR Specialist',
      'read_time': 10,
      'views_count': 312,
      'likes_count': 156,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'student-3',
      'title': 'Know Your Rights as a Worker',
      'content': '''Understanding your rights protects you in the workplace.

## Basic Worker Rights in Algeria

### Payment Rights
- Receive your agreed salary on time
- Get paid for overtime work
- Receive payslips showing deductions

### Working Conditions
- Safe and healthy work environment
- Maximum working hours per week
- Rest periods and breaks
- Annual paid leave

### Protection from Discrimination
- Equal treatment regardless of gender, religion, or background
- Protection from harassment
- Right to report misconduct

## What to Do If Rights Are Violated
1. Document everything (dates, times, witnesses)
2. Speak to your supervisor or HR
3. Keep copies of all communications
4. Know the labor inspection office contact
5. Seek legal advice if necessary

## Red Flags
- Employer keeps your ID documents
- No written contract provided
- Salary consistently late
- Unsafe working conditions
- Excessive unpaid overtime

## Resources
- Ministry of Labor hotline
- Local labor inspection office
- Worker rights organizations

Stay informed and don't be afraid to speak up!''',
      'category_id': 'worker-rights',
      'target_audience': 'student',
      'image_url': 'assets/images/education/worker-rights.jpg',
      'author': 'Legal Advisory',
      'read_time': 12,
      'views_count': 189,
      'likes_count': 134,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'student-4',
      'title': 'Interview Preparation Guide',
      'content': '''Ace your next interview with these proven strategies.

## Before the Interview

### Research
- Learn about the company
- Understand the job role
- Know the industry trends

### Preparation
- Review common interview questions
- Prepare your answers using STAR method
- Plan your outfit (professional attire)
- Prepare questions to ask them

## During the Interview

### Body Language
- Maintain eye contact
- Firm handshake
- Sit up straight
- Smile and be friendly

### Communication Tips
- Listen carefully to questions
- Take a moment to think before answering
- Be honest and authentic
- Provide specific examples

### Common Questions
1. "Tell me about yourself"
2. "Why do you want this job?"
3. "What are your strengths/weaknesses?"
4. "Where do you see yourself in 5 years?"
5. "Do you have any questions for us?"

## After the Interview
- Send a thank you email within 24 hours
- Reflect on what went well
- Note areas for improvement
- Be patient while waiting for response

## Virtual Interview Tips
- Test your technology beforehand
- Choose a quiet, well-lit location
- Look at the camera, not the screen
- Minimize distractions

Good luck!''',
      'category_id': 'interview-skills',
      'target_audience': 'student',
      'image_url': 'assets/images/education/interview-prep.jpg',
      'author': 'Career Coach',
      'read_time': 15,
      'views_count': 428,
      'likes_count': 267,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'student-5',
      'title': 'Building Professional Skills',
      'content': '''Develop the skills employers are looking for.

## Essential Soft Skills

### Communication
- Clear verbal and written expression
- Active listening
- Presentation skills

### Teamwork
- Collaboration and cooperation
- Conflict resolution
- Flexibility and adaptability

### Problem-Solving
- Critical thinking
- Creativity and innovation
- Decision-making

### Time Management
- Prioritization
- Meeting deadlines
- Organization

## Technical Skills to Learn
- Microsoft Office Suite
- Basic data analysis (Excel)
- Digital communication tools
- Industry-specific software

## How to Develop Skills

### Free Online Resources
- Coursera, edX, Khan Academy
- YouTube tutorials
- LinkedIn Learning

### Practice Opportunities
- Volunteer work
- Student organizations
- Internships and part-time jobs
- Personal projects

### Networking
- Attend career fairs
- Join professional groups
- Connect with alumni
- Use LinkedIn effectively

## Showcasing Your Skills
- Add to your CV
- Mention in cover letters
- Demonstrate in interviews
- Create a portfolio

Continuous learning is the key to career success!''',
      'category_id': 'skill-building',
      'target_audience': 'student',
      'image_url': 'assets/images/education/skills.jpg',
      'author': 'Skills Development Team',
      'read_time': 11,
      'views_count': 356,
      'likes_count': 198,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'employer-1',
      'title': 'Hiring Best Practices for Small Businesses',
      'content': '''Attract and retain the best talent for your business.

## Define Your Needs
- Create clear job descriptions
- Identify essential vs. desirable skills
- Determine salary range and benefits
- Consider culture fit

## Where to Post Jobs
- Online job platforms (like this app!)
- Social media
- University career centers
- Professional networks
- Employee referrals

## Screening Candidates

### Application Review
- Look for relevant experience
- Check for attention to detail
- Assess communication skills through application

### Interview Process
- Prepare structured questions
- Include skills assessments
- Consider multiple interview rounds
- Involve team members

## Red Flags
- Frequent job changes without reason
- Gaps in employment not explained
- Negative talk about previous employers
- Inability to provide references

## Making the Offer
- Be prompt in your decision
- Clearly communicate terms
- Provide written contract
- Set clear start date and expectations

## Onboarding New Hires
- Prepare workspace and equipment
- Assign a mentor or buddy
- Provide necessary training
- Set clear goals for first 90 days

Good hiring leads to business success!''',
      'category_id': 'recruitment',
      'target_audience': 'employer',
      'image_url': 'assets/images/education/hiring.jpg',
      'author': 'HR Consultant',
      'read_time': 13,
      'views_count': 167,
      'likes_count': 78,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'employer-2',
      'title': 'Writing Effective Job Posts',
      'content': '''Create job posts that attract quality candidates.

## Job Post Structure

### 1. Attention-Grabbing Title
- Be specific about the role
- Include key qualifications if needed
- Avoid jargon and abbreviations

### 2. Company Overview
- Brief introduction to your business
- What makes your company unique
- Company culture and values

### 3. Job Description
- Main responsibilities (bullet points)
- Day-to-day tasks
- Who they'll work with
- Growth opportunities

### 4. Requirements
**Must-Have:**
- Essential qualifications
- Required experience
- Necessary skills

**Nice-to-Have:**
- Preferred qualifications
- Bonus skills
- Additional experience

### 5. Compensation & Benefits
- Salary range (be transparent)
- Work schedule and hours
- Benefits offered
- Perks and extras

### 6. Application Instructions
- How to apply
- Required documents
- Application deadline
- Contact information

## Writing Tips
- Use clear, simple language
- Be honest and realistic
- Highlight what you offer
- Show your company personality
- Avoid discriminatory language
- Proofread carefully

## Examples of Good vs. Bad

**Bad:** "Looking for rockstar developer ninja"
**Good:** "Seeking Junior Software Developer (1-2 years experience)"

**Bad:** "Must be young and energetic"
**Good:** "Fast-paced environment, team-oriented"

Clarity attracts quality!''',
      'category_id': 'job-posting',
      'target_audience': 'employer',
      'image_url': 'assets/images/education/job-posting.jpg',
      'author': 'Recruitment Expert',
      'read_time': 9,
      'views_count': 203,
      'likes_count': 112,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'employer-3',
      'title': 'Managing Student Workers',
      'content': '''Get the best from your student employees.

## Understanding Student Workers

### Unique Characteristics
- Often first-time workers
- Balancing work with studies
- Limited availability
- Eager to learn
- Need guidance and structure

### Benefits
- Enthusiastic and energetic
- Tech-savvy
- Fresh perspectives
- Often more affordable
- Potential long-term employees

## Setting Up for Success

### Clear Expectations
- Written job description
- Defined work hours
- Performance metrics
- Communication protocols

### Training & Development
- Comprehensive onboarding
- Regular check-ins
- Skills training opportunities
- Mentorship programs

## Scheduling Best Practices
- Be flexible with exam periods
- Plan ahead for holidays
- Allow schedule swaps
- Give advance notice of shifts

## Communication Tips
- Use digital tools (messaging apps)
- Be clear and direct
- Provide regular feedback
- Encourage questions

## Common Challenges & Solutions

**Challenge:** Unreliable attendance
**Solution:** Set clear policies, document issues, have backup plans

**Challenge:** Lack of experience
**Solution:** Provide thorough training, be patient, give constructive feedback

**Challenge:** Academic priorities
**Solution:** Work around school schedule, be understanding during exams

## Retention Strategies
- Competitive pay
- Flexible scheduling
- Growth opportunities
- Recognition and appreciation
- Fun work environment

Invest in your student workers - they're your future!''',
      'category_id': 'management',
      'target_audience': 'employer',
      'image_url': 'assets/images/education/managing.jpg',
      'author': 'Business Management',
      'read_time': 14,
      'views_count': 145,
      'likes_count': 67,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'employer-4',
      'title': 'Legal Requirements for Employers',
      'content': '''Stay compliant with Algerian labor laws.

## Employment Contracts
- Must be in writing
- Include all terms and conditions
- Specify salary and benefits
- Define probation period
- Both parties must sign

## Working Hours & Overtime
- Standard work week: 40 hours
- Maximum daily hours: 8-10 (depending on sector)
- Overtime must be paid at higher rate
- Rest periods required

## Minimum Wage & Payment
- Must pay at least minimum wage
- Salary paid monthly
- Provide detailed payslips
- Cannot withhold payment

## Social Security
- Register employees with CNAS
- Make required contributions
- Provide work injury insurance
- Maintain proper records

## Leave Entitlements
- Annual paid leave: 30 days minimum
- Sick leave with medical certificate
- Maternity/paternity leave
- Religious holidays

## Workplace Safety
- Provide safe working conditions
- Supply necessary safety equipment
- Report workplace accidents
- Conduct safety training

## Termination Rules
- Must have valid reason
- Notice period required
- Severance pay may apply
- Proper documentation needed

## Record Keeping
- Employee files
- Attendance records
- Payroll documentation
- Contracts and amendments

## Penalties for Non-Compliance
- Fines
- Legal action
- Business closure
- Damage to reputation

## Resources
- Labor Inspection Office
- CNAS (Social Security)
- Chamber of Commerce
- Legal advisors

When in doubt, consult a lawyer!''',
      'category_id': 'legal-compliance',
      'target_audience': 'employer',
      'image_url': 'assets/images/education/legal.jpg',
      'author': 'Legal Compliance Team',
      'read_time': 16,
      'views_count': 189,
      'likes_count': 94,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('education_articles', {
      'id': 'employer-5',
      'title': 'Building a Positive Workplace Culture',
      'content': '''Create an environment where employees thrive.

## What is Workplace Culture?
The shared values, beliefs, and behaviors that shape your work environment.

## Benefits of Good Culture
- Higher employee satisfaction
- Better retention rates
- Increased productivity
- Positive reputation
- Easier recruitment

## Key Elements

### 1. Communication
- Open-door policy
- Regular team meetings
- Feedback mechanisms
- Clear expectations

### 2. Recognition & Appreciation
- Acknowledge good work
- Celebrate achievements
- Employee of the month
- Thank you notes

### 3. Work-Life Balance
- Flexible scheduling when possible
- Respect personal time
- Reasonable workloads
- Support during difficult times

### 4. Professional Development
- Training opportunities
- Skills workshops
- Mentorship programs
- Career advancement paths

### 5. Team Building
- Social events
- Team lunches
- Group activities
- Collaborative projects

## Creating Your Culture

### Step 1: Define Values
- What matters to your business?
- What behavior do you want to encourage?
- What's your mission?

### Step 2: Lead by Example
- Management sets the tone
- Walk the talk
- Be consistent
- Admit mistakes

### Step 3: Involve Employees
- Ask for input
- Implement suggestions
- Share decision-making
- Create committees

### Step 4: Make it Visible
- Post values in workplace
- Include in onboarding
- Reference in meetings
- Incorporate in reviews

## Warning Signs of Bad Culture
- High turnover
- Low morale
- Frequent conflicts
- Poor communication
- Lack of engagement

## Quick Wins
- Start meetings with good news
- Provide free coffee/tea
- Celebrate birthdays
- Casual dress Fridays
- Employee suggestion box

Culture is not created overnight, but every positive action counts!''',
      'category_id': 'workplace-culture',
      'target_audience': 'employer',
      'image_url': 'assets/images/education/culture.jpg',
      'author': 'Organizational Development',
      'read_time': 12,
      'views_count': 178,
      'likes_count': 89,
      'published_at': now,
      'created_at': now,
      'updated_at': now,
    });

    await db.insert('notifications', {
      'id': 'notif-1',
      'user_id': 'user123',
      'title': 'Welcome to Navigui!',
      'message':
          'Start exploring job opportunities and educational content tailored for you.',
      'type': 'system',
      'priority': 'medium',
      'is_read': 0,
      'is_pushed': 0,
      'created_at': now,
    });

    await db.insert('notifications', {
      'id': 'notif-2',
      'user_id': 'user123',
      'title': 'New Article Available',
      'message':
          'Check out "Your First Job: What to Expect" in the Learn section.',
      'type': 'application',
      'related_id': 'student-1',
      'related_type': 'article',
      'action_url': '/learn/article/student-1',
      'priority': 'low',
      'is_read': 0,
      'is_pushed': 0,
      'created_at':
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    });

    await db.insert('notifications', {
      'id': 'notif-3',
      'user_id': 'user123',
      'title': 'Complete Your Profile',
      'message':
          'Add your skills and experience to get better job recommendations.',
      'type': 'system',
      'priority': 'high',
      'is_read': 0,
      'is_pushed': 0,
      'created_at':
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    });

    await db.insert('notifications', {
      'id': 'notif-4',
      'user_id': 'user456',
      'title': 'Welcome Employer!',
      'message':
          'Start posting job opportunities and connect with talented students.',
      'type': 'system',
      'priority': 'medium',
      'is_read': 0,
      'is_pushed': 0,
      'created_at': now,
    });

    await db.insert('notifications', {
      'id': 'notif-5',
      'user_id': 'user456',
      'title': 'New Student Applications',
      'message':
          'You have 5 new applications to review for your recent job postings.',
      'type': 'application',
      'priority': 'high',
      'is_read': 0,
      'is_pushed': 0,
      'created_at':
          DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
    });

    await db.insert('notifications', {
      'id': 'notif-6',
      'user_id': 'user456',
      'title': 'Profile Views Increased',
      'message': 'Your company profile was viewed 45 times this week.',
      'type': 'system',
      'priority': 'low',
      'is_read': 0,
      'is_pushed': 0,
      'created_at':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    });

    print('Database seeded successfully');
    print('- 2 user accounts (1 student, 1 employer)');
    print('- 10 education articles (5 student, 5 employer)');
    print('- 6 sample notifications (3 student, 3 employer)');
  }
}
