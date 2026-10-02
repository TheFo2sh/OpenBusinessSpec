import "okeno-schema-markers";

@workObject("da008ce2-0a65-465c-8868-955b8e53f1df")
@icon("/iconify/mdi/book-open-variant.svg")
model Course {
  courseId: string;
  title: string;
  publishedRevision: string;
  lessonIds: string[];
}

@workObject("980c21bc-1751-4d18-b9b4-1fff0c05a590")
@icon("/iconify/mdi/account-plus-outline.svg")
model Enrollment {
  learnerId: string;
  course: Course;
  enrolledAt: utcDateTime;
  status: EnrollmentStatus;
}

@workObject("314c25c1-9ee6-4e85-947b-e35e8827c0f2")
@icon("/iconify/mdi/play-box-outline.svg")
model LessonProgress {
  enrollment: Enrollment;
  lessonId: string;
  status: LessonProgressStatus;
  startedAt?: utcDateTime;
  completedAt?: utcDateTime;
}

@workObject("0d129f3d-e421-4684-8f72-0c941cee46ca")
@icon("/iconify/mdi/progress-check.svg")
model LearningProgress {
  enrollment: Enrollment;
  currentLessonId?: string;
  completedLessonIds: string[];
  completionPercentage: float32;
  completedAt?: utcDateTime;
}

enum EnrollmentStatus {
  Active: "active",
  Completed: "completed",
  Withdrawn: "withdrawn",
}

enum LessonProgressStatus {
  NotStarted: "not_started",
  InProgress: "in_progress",
  Completed: "completed",
}
