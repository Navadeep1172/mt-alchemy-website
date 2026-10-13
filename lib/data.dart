import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// Navigation / Information Architecture
/// ---------------------------------------------------------------------------
class NavItem {
  final String path;
  final String label;
  final IconData icon;
  const NavItem(this.path, this.label, this.icon);
}

/// Top-level navigation required by the brief
/// (Home, About, Services, Upskilling, Store, Insights, Contact, Login/Register, Cart).
const topNav = <NavItem>[
  NavItem('/', 'Home', Icons.home_outlined),
  NavItem('/about', 'About', Icons.info_outline),
  NavItem('/services', 'Services', Icons.design_services_outlined),
  NavItem('/upskilling', 'Upskilling', Icons.school_outlined),
  NavItem('/store', 'Store', Icons.storefront_outlined),
  NavItem('/insights', 'Insights', Icons.article_outlined),
  NavItem('/contact', 'Contact', Icons.chat_bubble_outline),
];

/// Full sitemap (footer + drawer).
const allRoutes = <NavItem>[
  NavItem('/', 'Home', Icons.home_outlined),
  NavItem('/about', 'About', Icons.info_outline),
  NavItem('/services', 'Services', Icons.design_services_outlined),
  NavItem('/coaching', 'Individual Coaching', Icons.self_improvement),
  NavItem('/organisations', 'Organisations', Icons.apartment_outlined),
  NavItem('/programmes', 'Corporate Programmes', Icons.card_membership_outlined),
  NavItem('/upskilling', 'Learning Hub', Icons.school_outlined),
  NavItem('/store', 'Store', Icons.storefront_outlined),
  NavItem('/insights', 'Insights', Icons.article_outlined),
  NavItem('/impact', 'Impact Stories', Icons.auto_awesome_outlined),
  NavItem('/contact', 'Contact', Icons.chat_bubble_outline),
  NavItem('/login', 'Login / Register', Icons.login),
];

/// ---------------------------------------------------------------------------
/// Brand image assets extracted from the MT Alchemy company profile.
/// ---------------------------------------------------------------------------
class Img {
  static const hero = [
    'assets/images/img_009.jpg',
    'assets/images/img_006.jpg',
    'assets/images/img_027.jpg',
  ];
  static const banner = 'assets/images/img_003.jpg';
  static const features = [
    'assets/images/img_002.jpg',
    'assets/images/img_004.jpg',
    'assets/images/img_010.jpg',
    'assets/images/img_012.jpg',
    'assets/images/img_014.jpg',
    'assets/images/img_017.jpg',
    'assets/images/img_026.jpg',
    'assets/images/img_005.jpg',
  ];
  static const stories = [
    'assets/images/img_022.jpg',
    'assets/images/img_023.jpg',
    'assets/images/img_024.jpg',
    'assets/images/img_025.jpg',
    'assets/images/img_018.jpg',
    'assets/images/img_013.jpg',
    'assets/images/img_008.jpg',
    'assets/images/img_028.jpg',
  ];
  static const portraits = [
    'assets/images/img_019.jpg',
    'assets/images/img_011.jpg',
    'assets/images/img_007.jpg',
    'assets/images/img_016.jpg',
    'assets/images/img_015.jpg',
    'assets/images/img_021.jpg',
    'assets/images/img_020.jpg',
  ];
  static const products = [
    'assets/images/img_021.jpg',
    'assets/images/img_020.jpg',
    'assets/images/img_015.jpg',
    'assets/images/img_016.jpg',
    'assets/images/img_013.jpg',
    'assets/images/img_025.jpg',
  ];
}

/// ---------------------------------------------------------------------------
/// Domain models
/// ---------------------------------------------------------------------------
class ServiceItem {
  final IconData icon;
  final String title;
  final String blurb;
  final String whoFor;
  final List<String> objectives;
  const ServiceItem(this.icon, this.title, this.blurb, this.whoFor, this.objectives);
}

class CurriculumItem {
  final String title;
  final String type; // Video, PDF, Quiz, Text
  const CurriculumItem(this.title, this.type);
}

class Course {
  final String id;
  final String title;
  final String category;
  final String instructor;
  final String duration;
  final String level;
  final int modules;
  final double rating;
  final double price;
  final String image;
  final String description;
  final List<String> objectives;
  final List<CurriculumItem> curriculum;
  const Course({
    required this.id,
    required this.title,
    required this.category,
    required this.instructor,
    required this.duration,
    required this.level,
    required this.modules,
    required this.rating,
    required this.price,
    required this.image,
    required this.description,
    required this.objectives,
    required this.curriculum,
  });
}

class Product {
  final String id;
  final String name;
  final String type; // Digital / Physical
  final String category;
  final double price;
  final String description;
  final String image;
  final int stock;
  const Product({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
    this.stock = 0,
  });
}

class ImpactStory {
  final String title;
  final String clientType;
  final String programme;
  final String participants;
  final String objective;
  final String outcome;
  final String image;
  final List<String> tags;
  const ImpactStory(this.title, this.clientType, this.programme, this.participants,
      this.objective, this.outcome, this.image, this.tags);
}

class Article {
  final String title;
  final String category;
  final String type;
  final String image;
  const Article(this.title, this.category, this.type, this.image);
}

/// ---------------------------------------------------------------------------
/// Services directory (Services page - Employer)
/// ---------------------------------------------------------------------------
const services = <ServiceItem>[
  ServiceItem(Icons.psychology_alt_outlined, 'Emotional Intelligence & Mindfulness',
      'Build self-awareness, empathy and calm under pressure.', 'Individuals & Teams',
      ['Recognise and regulate emotions', 'Practise mindful attention', 'Strengthen empathy']),
  ServiceItem(Icons.record_voice_over_outlined, 'Leadership & Communication',
      'Develop leaders who listen well and lead with clarity.', 'Managers & Leaders',
      ['Communicate with clarity', 'Give and receive feedback', 'Lead through change']),
  ServiceItem(Icons.monitor_heart_outlined, 'Organisation Well-being Assessment',
      'Understand your workplace health and find where to act first.', 'HR & Leadership',
      ['Measure well-being', 'Identify risk areas', 'Recommend interventions']),
  ServiceItem(Icons.groups_outlined, 'Team Building & Effectiveness',
      'Strengthen trust, collaboration and engagement.', 'Whole Teams',
      ['Build psychological safety', 'Improve collaboration', 'Raise engagement']),
  ServiceItem(Icons.eco_outlined, 'CSR & ESG',
      'Purposeful programmes that connect people to impact.', 'Organisations',
      ['Design CSR activities', 'Connect teams to purpose', 'Report social impact']),
  ServiceItem(Icons.tune, 'Customized Programmes',
      'Designed around your workforce, culture and goals.', 'Everyone',
      ['Assess needs', 'Co-design content', 'Measure outcomes']),
];

/// ---------------------------------------------------------------------------
/// Courses (Learning Hub / LMS)
/// ---------------------------------------------------------------------------
const courses = <Course>[
  Course(
    id: 'eq101',
    title: 'Emotional Intelligence Fundamentals',
    category: 'Emotional Intelligence',
    instructor: 'Mabel Tan KH',
    duration: '4h 30m',
    level: 'Beginner',
    modules: 5,
    rating: 4.8,
    price: 199,
    image: 'assets/images/img_002.jpg',
    description:
        'Master the five pillars of emotional intelligence and apply them at work and in life.',
    objectives: [
      'Understand the five pillars of EQ',
      'Regulate emotions under pressure',
      'Practise empathy in conversations',
    ],
    curriculum: [
      CurriculumItem('Introduction to Emotional Intelligence', 'Video'),
      CurriculumItem('Self-Awareness & Self-Regulation', 'Video'),
      CurriculumItem('Empathy & Social Skills', 'PDF'),
      CurriculumItem('EQ at the Workplace', 'Video'),
      CurriculumItem('Knowledge Check', 'Quiz'),
    ],
  ),
  Course(
    id: 'mind102',
    title: 'Mindfulness at Work',
    category: 'Mindfulness',
    instructor: 'Mabel Tan KH',
    duration: '3h 10m',
    level: 'Beginner',
    modules: 4,
    rating: 4.7,
    price: 149,
    image: 'assets/images/img_004.jpg',
    description:
        'Practical mindfulness tools to reduce stress, focus attention and stay present.',
    objectives: [
      'Practise breathing and grounding',
      'Reduce workplace stress',
      'Build a daily mindfulness habit',
    ],
    curriculum: [
      CurriculumItem('What Mindfulness Really Is', 'Video'),
      CurriculumItem('Breathing & Grounding', 'Video'),
      CurriculumItem('Mindful Communication', 'PDF'),
      CurriculumItem('Reflection Quiz', 'Quiz'),
    ],
  ),
  Course(
    id: 'lead103',
    title: 'Human-Centred Leadership',
    category: 'Leadership',
    instructor: 'MT Alchemy Faculty',
    duration: '6h 00m',
    level: 'Intermediate',
    modules: 6,
    rating: 4.9,
    price: 299,
    image: 'assets/images/img_010.jpg',
    description:
        'Lead with clarity and care: communicate vision, coach your people and build trust.',
    objectives: [
      'Set direction with clarity',
      'Coach instead of command',
      'Lead high-trust teams',
    ],
    curriculum: [
      CurriculumItem('Leadership in an AI-Driven World', 'Video'),
      CurriculumItem('Vision & Clarity', 'Video'),
      CurriculumItem('Coaching Conversations', 'Video'),
      CurriculumItem('Feedback That Works', 'PDF'),
      CurriculumItem('Leading Through Change', 'Video'),
      CurriculumItem('Leadership Assessment', 'Quiz'),
    ],
  ),
  Course(
    id: 'comm104',
    title: 'Communication That Connects',
    category: 'Communication',
    instructor: 'MT Alchemy Faculty',
    duration: '2h 45m',
    level: 'Beginner',
    modules: 4,
    rating: 4.6,
    price: 129,
    image: 'assets/images/img_012.jpg',
    description: 'Listen deeply, speak clearly and handle difficult conversations with grace.',
    objectives: ['Listen actively', 'Structure a message', 'Handle conflict calmly'],
    curriculum: [
      CurriculumItem('Active Listening', 'Video'),
      CurriculumItem('Structuring Your Message', 'PDF'),
      CurriculumItem('Difficult Conversations', 'Video'),
      CurriculumItem('Practice Quiz', 'Quiz'),
    ],
  ),
  Course(
    id: 'team105',
    title: 'Building Effective Teams',
    category: 'Team Effectiveness',
    instructor: 'MT Alchemy Faculty',
    duration: '5h 20m',
    level: 'Intermediate',
    modules: 5,
    rating: 4.7,
    price: 249,
    image: 'assets/images/img_014.jpg',
    description: 'Turn a group of individuals into a trusting, collaborative team.',
    objectives: ['Build psychological safety', 'Define team norms', 'Run great meetings'],
    curriculum: [
      CurriculumItem('Stages of Team Development', 'Video'),
      CurriculumItem('Trust & Psychological Safety', 'Video'),
      CurriculumItem('Team Norms', 'PDF'),
      CurriculumItem('Collaboration Tools', 'Video'),
      CurriculumItem('Team Health Quiz', 'Quiz'),
    ],
  ),
  Course(
    id: 'well106',
    title: 'Workplace Well-being Essentials',
    category: 'Workplace Well-being',
    instructor: 'MT Alchemy Faculty',
    duration: '3h 30m',
    level: 'Beginner',
    modules: 4,
    rating: 4.8,
    price: 159,
    image: 'assets/images/img_017.jpg',
    description: 'Protect your energy, spot burnout early and support the people around you.',
    objectives: ['Spot burnout signals', 'Protect personal energy', 'Support colleagues'],
    curriculum: [
      CurriculumItem('Understanding Burnout', 'Video'),
      CurriculumItem('Energy Management', 'Video'),
      CurriculumItem('Supporting Others', 'PDF'),
      CurriculumItem('Well-being Check', 'Quiz'),
    ],
  ),
];

/// ---------------------------------------------------------------------------
/// Store products (digital + physical)
/// ---------------------------------------------------------------------------
const products = <Product>[
  Product(id: 'p1', name: 'Emotional Clarity Workbook', type: 'Digital', category: 'Workbooks', price: 45,
      description: 'A guided digital workbook to build emotional awareness step by step.',
      image: 'assets/images/img_021.jpg'),
  Product(id: 'p2', name: 'Mindfulness Journal', type: 'Physical', category: 'Journals', price: 79,
      description: 'A beautifully printed journal for daily reflection and gratitude.',
      image: 'assets/images/img_020.jpg', stock: 120),
  Product(id: 'p3', name: 'EQ Conversation Cards', type: 'Physical', category: 'Learning Kits', price: 59,
      description: '52 prompts to spark meaningful conversations in your team.',
      image: 'assets/images/img_015.jpg', stock: 80),
  Product(id: 'p4', name: 'Leadership Toolkit (PDF)', type: 'Digital', category: 'Templates', price: 39,
      description: 'Ready-to-use templates for feedback, coaching and one-on-ones.',
      image: 'assets/images/img_016.jpg'),
  Product(id: 'p5', name: 'Recorded Workshop: EQ 101', type: 'Digital', category: 'Recorded Workshops', price: 99,
      description: 'A full recording of our most popular emotional intelligence workshop.',
      image: 'assets/images/img_013.jpg'),
  Product(id: 'p6', name: 'Team Well-being Assessment', type: 'Digital', category: 'Assessment Resources', price: 149,
      description: 'A ready assessment to measure your team well-being and engagement.',
      image: 'assets/images/img_025.jpg'),
];

/// ---------------------------------------------------------------------------
/// Impact stories (from MT Alchemy portfolio)
/// ---------------------------------------------------------------------------
const impactStories = <ImpactStory>[
  ImpactStory('Corporate Team Building Retreat', 'Corporate', 'Team Building & Effectiveness',
      '120 participants', 'Strengthen trust across departments after a restructure.',
      'Measurable lift in cross-team collaboration and engagement scores.',
      'assets/images/img_022.jpg', ['Team Building', 'Corporate']),
  ImpactStory('Mindfulness for Educators', 'Education', 'Mindfulness & Well-being',
      '60 educators', 'Equip teachers with tools to manage classroom stress.',
      'Reduced reported stress and improved classroom climate.',
      'assets/images/img_023.jpg', ['Mindfulness', 'Education']),
  ImpactStory('Leadership Lab for Youth', 'Youth', 'Leadership Development',
      '45 youths', 'Build confidence and leadership skills for young leaders.',
      'Participants led community projects with visible social impact.',
      'assets/images/img_024.jpg', ['Leadership', 'Youth']),
  ImpactStory('Communication Workshop for NGOs', 'NGO', 'Communication',
      '35 staff', 'Improve communication and teamwork across field teams.',
      'Clearer reporting and stronger team morale.',
      'assets/images/img_025.jpg', ['Communication', 'NGO']),
  ImpactStory('Community EQ Programme', 'Community', 'Emotional Intelligence',
      '200 participants', 'Bring emotional intelligence to community volunteers.',
      'Volunteers report better resilience and empathy in service.',
      'assets/images/img_018.jpg', ['Emotional Intelligence', 'Community']),
  ImpactStory('Corporate Well-being Day', 'Corporate', 'Workplace Well-being',
      '180 participants', 'Reset team energy and prevent burnout.',
      'Higher engagement and a shared well-being language across the company.',
      'assets/images/img_013.jpg', ['Corporate']),
];

/// Filter chips for the Impact Stories page.
const impactFilters = [
  'All', 'Corporate', 'Education', 'Youth', 'NGO', 'Community',
  'Leadership', 'Mindfulness', 'Emotional Intelligence', 'Team Building',
];

/// ---------------------------------------------------------------------------
/// Insights / content platform
/// ---------------------------------------------------------------------------
const articles = <Article>[
  Article('Why Emotional Intelligence Matters in an AI-Driven World', 'Emotional Intelligence', 'Article', 'assets/images/img_026.jpg'),
  Article('Five Leadership Habits That Build Trust', 'Leadership', 'Guide', 'assets/images/img_005.jpg'),
  Article('A 3-Minute Mindfulness Reset for Busy Days', 'Mindfulness', 'Video', 'assets/images/img_002.jpg'),
  Article('How to Give Feedback Without Triggering Defensiveness', 'Communication', 'Article', 'assets/images/img_004.jpg'),
  Article('Spotting Burnout Before It Spreads', 'Workplace', 'Guide', 'assets/images/img_017.jpg'),
  Article('Designing Your Own Personal Growth Plan', 'Personal Development', 'Resource', 'assets/images/img_014.jpg'),
];

const insightCategories = [
  'Emotional Intelligence', 'Leadership', 'Mindfulness', 'Communication',
  'Workplace', 'Personal Development', 'Organizational Development',
];

const testimonials = [
  ('A truly human-centred programme that changed how our team talks to each other.',
      'HR Director, Manufacturing'),
  ('Mabel connected with our people instantly. The energy stayed long after the workshop.',
      'Operations Manager, Logistics'),
  ('Practical, warm and deeply insightful. We still use the tools every week.',
      'Head of People, Education Group'),
];

/// Course categories for the Learning Hub.
const courseCategories = [
  'Emotional Intelligence', 'Mindfulness', 'Leadership', 'Communication',
  'Team Effectiveness', 'Workplace Well-being', 'Personal Development',
  'Organizational Development',
];

/// Company registration form dropdown options.
const countries = [
  'Malaysia', 'Singapore', 'Indonesia', 'Thailand', 'Vietnam',
  'Philippines', 'Brunei', 'India', 'Australia', 'United Kingdom', 'Other',
];

const hobbies = ['Reading', 'Sports', 'Music', 'Travel'];
