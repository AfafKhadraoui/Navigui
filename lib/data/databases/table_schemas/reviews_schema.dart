// lib/data/databases/table_schemas/reviews_schema.dart

import 'package:sqflite/sqflite.dart';

class ReviewsSchema {
  static const String tableName = 'reviews';

  static Future<void> create(Database db) async {
    // Create reviews table (dual-sided ratings)
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        reviewer_id TEXT NOT NULL,
        reviewee_id TEXT NOT NULL,
        job_id TEXT,
        application_id TEXT,
        rating REAL NOT NULL CHECK(rating >= 1 AND rating <= 5),
        communication_rating REAL,
        payment_rating REAL,
        work_environment_rating REAL,
        overall_experience_rating REAL,
        quality_rating REAL,
        time_respect_rating REAL,
        comment TEXT,
        is_visible INTEGER DEFAULT 1,
        is_reported INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (reviewee_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE SET NULL,
        FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE SET NULL
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_reviews_reviewee ON $tableName(reviewee_id)');
    await db.execute('CREATE INDEX idx_reviews_job ON $tableName(job_id)');
  }
}
