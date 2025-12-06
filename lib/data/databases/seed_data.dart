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

    final now = DateTime.now();
    final nowString = now.toIso8601String();

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
      'created_at': nowString,
      'updated_at': nowString,
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
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'student-1',
      'title': 'Your First Job',
      'content':
          '''Starting your first job is an exciting milestone that marks the beginning of your professional journey. Whether you're fresh out of school or transitioning from student life to the workforce, understanding what to expect can help ease those first-day jitters and set you up for success.

## Preparing Before Day One

The days leading up to your first job are crucial. Review your employment contract thoroughly—understand your salary, benefits, working hours, and any probation period. Don't hesitate to ask HR if something isn't clear. Prepare all necessary documents including your national ID, educational certificates, social security information, and bank details for salary deposits.

Plan your commute ahead of time. Do a test run during the same hours you'll be commuting to account for traffic. Know exactly how long it takes and add buffer time. Being late on your first day creates a bad impression that's hard to shake off.

## Your First Day Experience

Arrive at least 15 minutes early on your first day. This shows punctuality and gives you time to compose yourself, use the restroom, and get your bearings. Dress professionally—when in doubt, it's better to be slightly overdressed than too casual. You can always adjust once you understand the office culture.

Bring a notebook and several pens. You'll be receiving lots of information, meeting new people, and learning processes. Taking notes shows you're engaged and helps you remember important details. Don't rely on your phone for notes on the first day—it might look like you're distracted.

Expect to feel overwhelmed. You'll likely meet many people whose names you won't remember, learn about systems and processes that seem complex, and receive more information than you can absorb. This is completely normal. Everyone has been in your shoes.

## Common First-Week Mistakes to Avoid

**Punctuality matters.** Being late or absent without proper notice, especially in your first weeks, signals unreliability. If you're sick or have an emergency, call your supervisor as early as possible—don't just send a text message.

**Watch your phone usage.** While some workplaces are relaxed about phones, err on the side of caution initially. Excessive phone use, especially for personal calls or social media, suggests you're not focused on work. Keep personal phone use to lunch breaks until you understand the office norms.

**Avoid office gossip.** You might notice people complaining or gossiping about colleagues, managers, or the company. Don't participate, even if you're trying to fit in. Stay neutral and positive. Negativity can quickly damage your reputation.

**Ask questions.** The biggest mistake new employees make is pretending to understand when they don't. It's far better to ask for clarification than to make mistakes because you were afraid to seem ignorant. Most people appreciate when you ask questions—it shows you care about doing things correctly.

## Building Strong Relationships

Your relationships with colleagues are just as important as your technical skills. Be respectful and friendly to everyone, from the CEO to the cleaning staff. You never know who might become a valuable connection or mentor.

Show initiative and willingness to help. If you finish your tasks early, ask if there's anything else you can assist with. Volunteer for projects when appropriate. This demonstrates enthusiasm and a team-player attitude.

Communicate clearly and professionally. Whether it's emails, messages, or face-to-face conversations, express yourself clearly and respectfully. Use proper grammar and avoid too much slang or emojis in professional communications.

## Learning and Growing

Accept feedback graciously. When your supervisor or colleagues give you constructive criticism, don't take it personally. See it as an opportunity to improve. Thank them for the feedback and show that you're implementing their suggestions.

Observe and learn from experienced colleagues. Notice how they handle difficult situations, communicate with clients, or manage their time. Ask if you can shadow them on certain tasks to learn their techniques.

Be patient with yourself. You won't master everything in a week or even a month. Professional skills develop over time through practice and experience. Focus on gradual improvement rather than perfection.

## Understanding Workplace Culture

Every workplace has its own culture—the unwritten rules about how people interact, dress, communicate, and work. Spend your first weeks observing: Do people eat lunch together or separately? Is the environment formal or casual? Do people socialize after work? Understanding these dynamics helps you integrate smoothly.

Pay attention to communication norms. Some offices prefer email for everything, others use messaging apps, and some rely on face-to-face conversations. Match the communication style of your workplace.

## Managing Work-Life Balance

Starting a new job is demanding, but remember to maintain balance. Get adequate sleep, eat properly, and make time for exercise and relaxation. Burnout is real, and taking care of yourself ensures you can perform well at work.

Don't be afraid to use your break times. They exist for a reason. Step away from your desk, stretch, or take a short walk. This helps you return refreshed and more focused.

## Final Thoughts

Remember, everyone was new once. Your colleagues understand that you're learning, and most will be happy to help. The key is showing that you're eager to learn, willing to work hard, and able to adapt.

Your first job is more than just earning money—it's where you develop professional skills, build your work ethic, and establish patterns that will serve you throughout your career. Approach it with curiosity, humility, and enthusiasm.

Give yourself at least three months to truly settle in. The first few weeks might feel chaotic, but stick with it. Before you know it, you'll be the experienced one helping the next new hire find their way!''',
      'category_id': 'career-tips',
      'target_audience': 'student',
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Career Advisory Team',
      'read_time': 6,
      'views_count': 245,
      'likes_count': 89,
      'published_at': now.subtract(Duration(days: 5)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'student-2',
      'title': 'Application Tips',
      'content':
          '''Your job application is often the first contact a potential employer has with you. In today's competitive job market, a well-crafted application can make the difference between landing an interview and being overlooked. This comprehensive guide will walk you through creating applications that stand out for all the right reasons.

## Understanding the Application Package

A complete job application typically consists of three main components: a cover letter, your CV or resume, and references. Each serves a distinct purpose and requires careful attention to detail.

Your **cover letter** is your personal introduction—it's where you explain why you're interested in the specific position and company, and how your background makes you an ideal candidate. Think of it as your chance to tell your story beyond the bullet points of your CV.

Your **CV or resume** is a structured document that presents your education, work experience, skills, and achievements. It should be easy to scan quickly while providing enough detail to showcase your qualifications.

**References** are professional contacts who can vouch for your character, work ethic, and abilities. Choose people who know your work well and will speak positively about you.

## Crafting an Effective Cover Letter

A strong cover letter is personalized, concise, and compelling. Start by researching the company and the hiring manager's name—addressing someone by name shows you've done your homework and care enough to personalize your application.

Begin with a strong opening that immediately states which position you're applying for and where you saw it advertised. Then, in one sentence, give a compelling reason why you're interested. Avoid generic statements like "I'm a hard worker"—be specific about what attracts you to this role or company.

The body of your cover letter should highlight 2-3 relevant experiences or skills that make you a strong candidate. Don't just repeat what's in your CV; instead, provide context and tell mini-stories. For example, instead of saying "I have customer service experience," write "During my part-time role at a busy cafe, I developed strong customer service skills by handling an average of 50 customers per shift while maintaining a friendly, efficient atmosphere."

Use the STAR method (Situation, Task, Action, Result) to structure your examples. This approach helps you provide concrete evidence of your capabilities rather than just making claims.

Close your cover letter by expressing enthusiasm for the opportunity to discuss your application further. Keep your tone professional but let your genuine interest shine through. Thank them for their consideration and provide your contact information.

Keep your cover letter to one page maximum. Hiring managers are busy—they appreciate conciseness. Every sentence should serve a purpose. If it doesn't add value or new information, cut it.

## Building a Strong CV

Your CV should be clean, well-organized, and easy to read. Use a professional font (like Arial, Calibri, or Times New Roman) in 10-12 point size. Stick to a simple, uncluttered format with clear section headings.

**Contact Information**: Start with your full name (larger font), phone number, email address, and location (city and country). Make sure your email address is professional—ideally firstname.lastname@email.com. Avoid usernames like "coolboy99" or "partygirl"—they create a poor impression.

**Personal Summary**: Include a brief 2-3 sentence summary at the top highlighting who you are professionally and what you're seeking. For example: "Recent Computer Science graduate with strong programming skills in Java and Python. Seeking entry-level software development position to apply academic knowledge and contribute to innovative projects."

**Education**: List your educational background in reverse chronological order (most recent first). Include the institution name, degree or diploma earned, dates attended, and your GPA if it's strong (above 3.0 or equivalent). You can also mention relevant coursework, academic honors, or major projects.

**Work Experience**: This is often the most important section. List each position with the company name, your job title, dates of employment, and 3-5 bullet points describing your responsibilities and achievements. Focus on accomplishments rather than just duties. Use action verbs and quantify results when possible.

For example, instead of "Responsible for social media," write "Managed Instagram account, increasing followers by 40% over six months through consistent content posting and engagement strategies."

If you don't have much formal work experience, include volunteer work, internships, significant school projects, or leadership roles in student organizations. All demonstrate valuable skills.

**Skills**: Create a dedicated skills section highlighting both technical and soft skills relevant to the job. For technical skills (like software, languages, tools), be honest about your proficiency level. For soft skills (communication, teamwork, problem-solving), you'll demonstrate these through your examples rather than just listing them.

**Additional Sections**: Depending on your background, you might include sections for:
- Certifications or training
- Languages spoken (with proficiency levels)
- Volunteer work
- Publications or presentations
- Professional memberships
- Awards and honors

**Formatting Tips**: Use bullet points rather than paragraphs for easy scanning. Maintain consistent formatting throughout—if you bold one job title, bold all job titles. Use the same date format throughout. Ensure adequate white space; a cramped CV is hard to read.

## Avoiding Common Application Mistakes

**Generic Applications**: The #1 mistake is sending the same generic application to every job. Employers can tell when you've mass-applied. Tailor each application to the specific role—mention the company name, reference specific job requirements, and explain why you're interested in *that* particular position.

**Spelling and Grammar Errors**: Typos and grammar mistakes signal carelessness. They can instantly disqualify you, especially for roles requiring attention to detail. Proofread multiple times, read your application aloud, use spell-check, and if possible, have someone else review it.

**Including Irrelevant Information**: Your application should be relevant to the job you're applying for. Don't list every job you've ever had or every hobby. Focus on what matters for this specific role. If you worked as a lifeguard years ago but you're now applying for an accounting position, it might not need much detail unless you can draw relevant connections.

**Lying or Exaggerating**: Never lie about your qualifications, experience, or achievements. It's easy for employers to verify information, and dishonesty will disqualify you or get you fired later. It's fine to present your experience in the best light, but stay truthful.

**Using Unprofessional Elements**: This includes overly casual language, emojis, decorative fonts, photos (unless specifically requested), or trying to be overly creative with format when applying to traditional industries. Save creativity for creative fields; most employers prefer clean, professional formats.

**Ignoring Instructions**: If the job posting says "include salary expectations" or "answer these three questions," do it. Failing to follow application instructions suggests you don't pay attention to details.

**Being Too Modest or Too Boastful**: Strike a balance. Don't undersell your achievements, but don't sound arrogant either. Use confident language ("I successfully led..." rather than "I kind of helped with...") while remaining humble and focused on facts.

## The Follow-Up Strategy

After submitting your application, send a brief, professional thank-you email within 24 hours (if you have a contact email). This shows professionalism and keeps you on their radar. Keep it simple: thank them for considering your application, reiterate your interest, and mention you look forward to hearing from them.

Be patient but proactive. If the job posting mentioned a timeframe for decisions, wait until that period has passed before following up. If no timeframe was given, wait about a week or two before sending a polite follow-up email inquiring about the status of your application.

Keep detailed records of all applications you submit: company name, position, date applied, contact information, and any follow-up actions. This helps you stay organized and avoid confusion if multiple companies contact you.

## Tailoring to Different Job Levels

**For Entry-Level Positions**: Emphasize your education, relevant coursework, internships, volunteer work, and transferable skills. Highlight your enthusiasm, willingness to learn, and any relevant projects. Employers hiring entry-level know you won't have extensive experience—they're looking for potential, attitude, and basic competencies.

**For Part-Time or Student Jobs**: Focus on flexibility, reliability, and any relevant experience. Emphasize soft skills like customer service, teamwork, and time management. Show that you understand the balance between work and studies and can handle both responsibly.

## Final Checklist Before Submitting

Before hitting send, verify:
- ✓ Correct company and position names are used throughout
- ✓ No spelling or grammar errors
- ✓ All requested documents are attached
- ✓ Files are named professionally (e.g., "FirstName_LastName_CV.pdf")
- ✓ Email address and phone number are correct
- ✓ You've followed all application instructions
- ✓ Documents are in the requested format (PDF is usually safest)
- ✓ Your tone is professional throughout

## Remember

Your application is your marketing tool—it's how you sell yourself to potential employers. Invest time in making it strong, specific, and professional. A well-crafted application opens doors; a careless one closes them. Every application is an opportunity to practice and improve. Even if you don't get the job, you're building valuable skills in self-presentation that will serve you throughout your career.

Quality beats quantity. It's better to submit five excellent, tailored applications than twenty generic ones. Good luck!''',
      'category_id': 'application-tips',
      'target_audience': 'student',
      'image_url': 'assets/images/education/Technology.png',
      'author': 'HR Specialist',
      'read_time': 8,
      'views_count': 312,
      'likes_count': 156,
      'published_at': now.subtract(Duration(days: 10)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'student-3',
      'title': 'Worker Rights',
      'content':
          '''As a young worker entering the Algerian job market, understanding your rights is essential for protecting yourself and ensuring fair treatment. Many first-time employees don't know what they're entitled to, which can lead to exploitation. This guide will help you understand your fundamental rights as a worker in Algeria and what to do if those rights are violated.

## Your Fundamental Rights in Algeria

Algeria's labor laws provide comprehensive protection for workers. These rights exist whether you're in a full-time permanent position, a part-time job, or a fixed-term contract. Knowing these rights empowers you to recognize when something isn't right and to advocate for yourself appropriately.

### Payment and Compensation Rights

You have the absolute right to receive your agreed-upon salary on time, in full, and in the currency specified in your contract (typically Algerian Dinars). Your salary should be paid at regular intervals—monthly for most positions—and payment should occur on or before the agreed date.

Your employer must provide you with detailed payslips showing your gross salary, all deductions (social security, taxes, etc.), and your net pay. These payslips are important financial records—keep them safe. They serve as proof of employment and income for various purposes like loans or renting.

If you work overtime (beyond your contracted hours), you're entitled to additional compensation. Overtime rates are typically higher than regular hourly rates, usually 50-75% more depending on when the overtime occurs (weekdays, weekends, or holidays). Your employer cannot force you to work unpaid overtime—this is illegal.

The national minimum wage (SNMG) sets the floor for compensation. Your employer cannot legally pay you less than this amount for full-time work. The minimum wage is periodically adjusted, so stay informed about current rates.

### Working Hours and Rest Periods

The standard legal working week in Algeria is 40 hours, typically distributed across five days. Your employer cannot require you to work more than this regularly without proper overtime compensation. Daily working hours are generally capped at 8-10 hours depending on your sector.

You're entitled to regular breaks during your workday. For a typical 8-hour day, this includes at least a 30-minute meal break (often an hour in practice). You should also have short rest periods, though the exact timing and duration can vary by workplace.

Weekly rest is mandatory—you must have at least one full day off per week (24 consecutive hours), typically Friday or Sunday. If your job requires weekend work (like in retail or hospitality), you should receive a different weekly rest day and potentially additional compensation.

### Annual Leave and Holidays

Every worker in Algeria is entitled to paid annual leave. The minimum is 30 calendar days per year (about 4-5 weeks), though this increases with seniority in some cases. This is among the most generous vacation policies globally—don't let anyone tell you you're not entitled to it.

You accumulate leave throughout the year and can typically use it after completing a certain period of employment (often six months to a year for new employees). Your employer cannot refuse to let you take your accumulated leave indefinitely, though they can ask you to coordinate timing to avoid disrupting business operations.

National and religious holidays are also paid days off. You should not have to work on these days unless your job specifically requires it (like healthcare or security), in which case you should receive additional compensation or alternative rest days.

### Safe and Healthy Working Conditions

You have the right to work in an environment that doesn't pose unreasonable risks to your health and safety. Your employer must provide:
- Safe equipment and tools
- Adequate lighting, ventilation, and temperature control
- Clean sanitary facilities
- Safety equipment if your job involves hazards (helmets, gloves, etc.)
- Training on safety procedures

If you notice unsafe conditions, you have the right to report them without fear of retaliation. In cases of immediate danger, you can refuse to work until the situation is corrected.

### Protection from Discrimination and Harassment

Algerian law protects workers from discrimination based on gender, age, race, religion, disability, or political views. You should receive equal pay for equal work regardless of these factors. You cannot be denied employment, promotion, or training opportunities based on discriminatory reasons.

Harassment—whether sexual, verbal, or psychological—is illegal and unacceptable. This includes unwanted comments, jokes, touching, or any behavior that creates a hostile or intimidating work environment. Your employer has a responsibility to prevent harassment and address it promptly when reported.

### Contract and Documentation Rights

You're entitled to a written employment contract that clearly states your position, salary, working hours, location, start date, and other key terms. Never agree to work without a written contract—verbal agreements are difficult to enforce and leave you vulnerable.

Your employer cannot confiscate your personal documents (national ID card, diplomas, passport). If an employer asks to "keep" your papers for any reason, this is a major red flag and potentially illegal. You can provide copies for their files, but originals should remain with you.

## Recognizing Red Flags and Violations

### Warning Signs of Problematic Employers

Certain practices clearly indicate an employer isn't respecting workers' rights:

**Salary Issues**: Consistently late payments, partial payments without explanation, paying less than agreed, or making illegal deductions are serious violations. One late payment might be an administrative error, but repeated problems indicate deeper issues.

**Contract Problems**: No written contract, vague contract terms, forcing you to sign a blank contract, or significantly different conditions from what was promised during hiring all signal trouble.

**Excessive Unpaid Work**: Requiring regular unpaid overtime, forcing you to work through breaks, or expecting work outside normal hours without compensation exploits workers.

**Unsafe Conditions**: Ignoring obvious safety hazards, not providing necessary safety equipment, or retaliating against employees who raise safety concerns shows disregard for worker welfare.

**Harassment or Discrimination**: Any form of harassment, discriminatory treatment, or creating a hostile work environment violates your rights and the law.

**Document Retention**: Keeping your ID card, diplomas, or other personal documents is a control tactic that prevents you from leaving freely—this is unacceptable.

## What to Do If Your Rights Are Violated

### Step 1: Document Everything

Keep detailed records of any violations:
- Dates and times of incidents
- What happened and who was involved
- Any witnesses present
- Photos or copies of relevant documents
- Written communications (emails, messages)

This documentation is crucial if you need to file a complaint or take legal action. Keep these records securely outside the workplace—don't rely on company computers or files you might lose access to.

### Step 2: Internal Resolution Attempts

Start by addressing issues internally when possible. This isn't always appropriate (especially for serious violations like harassment), but for many issues, it's a reasonable first step:

**Speak to Your Direct Supervisor**: Sometimes issues stem from misunderstandings or your supervisor being unaware. Explain the problem clearly and professionally. Document this conversation in writing (follow-up email summarizing what you discussed).

**Contact HR or Management**: If your supervisor doesn't resolve the issue or is part of the problem, escalate to human resources or higher management. Submit complaints in writing and keep copies.

### Step 3: External Resources and Complaints

If internal attempts fail or the violation is serious:

**Labor Inspection Office**: The Ministry of Labor has local offices (Inspection du Travail) that handle worker complaints. They can investigate your employer and enforce compliance with labor law. Find your local office contact information online or by calling the Ministry.

**File a Formal Complaint**: You can submit a written complaint to the labor inspection office detailing the violations. Include your documentation. They have the authority to inspect your workplace, interview people, and require your employer to correct violations.

**Legal Consultation**: For serious violations or if you've lost your job unfairly, consult with a lawyer specializing in labor law. Initial consultations are often free or low-cost. They can advise you on your options, including potentially filing a lawsuit.

**Worker Organizations**: Some sectors have unions or worker associations that can provide support, advice, and advocacy. These organizations know labor law well and can help you navigate the complaint process.

### Step 4: Protecting Yourself from Retaliation

Unfortunately, some employers retaliate against workers who assert their rights. Algerian law prohibits this retaliation, but it happens. Protect yourself by:
- Keeping all documentation secure and backed up
- Having witnesses when possible
- Documenting any retaliatory actions
- Reporting retaliation to labor authorities
- Consulting with a lawyer if you fear losing your job

## Special Considerations for Student Workers

If you're working while studying, you have the same rights as any other worker. Your employer cannot treat you differently or pay you less simply because you're a student (except in specific apprenticeship or training programs with different regulations).

However, be realistic about balancing work and studies. Make sure your job allows adequate time for classes and studying. Some students accept exploitative conditions thinking they have no alternatives, but your education is an investment in your future—don't let work jeopardize it.

## Building a Culture of Rights Awareness

Understanding your rights isn't about being confrontational or difficult. It's about ensuring fair treatment and sustainable working conditions. Good employers actually appreciate employees who understand labor law because it demonstrates professionalism and helps maintain legal compliance.

Share this knowledge with peers and coworkers. Many workers suffer violations simply because they don't know better. Creating awareness helps everyone and encourages employers to maintain proper standards.

## Resources for More Information

- **Ministry of Labor Website**: Official information about labor laws and regulations
- **Local Labor Inspection Office**: Direct assistance with complaints and questions
- **Legal Aid Organizations**: Free or low-cost legal consultation for workers
- **Worker Rights NGOs**: Organizations dedicated to protecting and advocating for workers

## Remember

You deserve fair treatment, safe conditions, and respect at work. Knowing your rights gives you power—the power to recognize problems, speak up appropriately, and take action when necessary.

Don't let fear of losing your job prevent you from asserting your rights. Employers who violate labor law often count on workers being too afraid or uninformed to complain. By standing up for yourself (appropriately and through proper channels), you not only protect yourself but also contribute to better working conditions for everyone.

Stay informed, document everything, and don't hesitate to seek help when needed. Your rights matter!''',
      'category_id': 'worker-rights',
      'target_audience': 'student',
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Legal Advisory',
      'read_time': 9,
      'views_count': 189,
      'likes_count': 134,
      'published_at': now.subtract(Duration(days: 15)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'student-4',
      'title': 'Interview Success',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Career Coach',
      'read_time': 7,
      'views_count': 428,
      'likes_count': 267,
      'published_at': now.subtract(Duration(days: 20)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'student-5',
      'title': 'Build Your Skills',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Skills Development Team',
      'read_time': 5,
      'views_count': 356,
      'likes_count': 198,
      'published_at': now.subtract(Duration(days: 25)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'employer-1',
      'title': 'Hiring Best Practices',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'HR Consultant',
      'read_time': 6,
      'views_count': 167,
      'likes_count': 78,
      'published_at': now.subtract(Duration(days: 7)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'employer-2',
      'title': 'Write Job Posts',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Recruitment Expert',
      'read_time': 5,
      'views_count': 203,
      'likes_count': 112,
      'published_at': now.subtract(Duration(days: 12)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'employer-3',
      'title': 'Manage Student Workers',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Business Management',
      'read_time': 7,
      'views_count': 145,
      'likes_count': 67,
      'published_at': now.subtract(Duration(days: 18)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'employer-4',
      'title': 'Legal Requirements',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Legal Compliance Team',
      'read_time': 8,
      'views_count': 189,
      'likes_count': 94,
      'published_at': now.subtract(Duration(days: 22)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
    });

    await db.insert('education_articles', {
      'id': 'employer-5',
      'title': 'Workplace Culture',
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
      'image_url': 'assets/images/education/Technology.png',
      'author': 'Organizational Development',
      'read_time': 6,
      'views_count': 178,
      'likes_count': 89,
      'published_at': now.subtract(Duration(days: 3)).toIso8601String(),
      'created_at': nowString,
      'updated_at': nowString,
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
      'created_at': nowString,
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
      'created_at': nowString,
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
