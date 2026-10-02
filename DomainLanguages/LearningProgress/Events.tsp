import "okeno-schema-markers";

@icon("/iconify/mdi/account-plus-outline.svg")
@event("f81603d4-a9bc-4fa7-8e43-1eb8684299f6", source:"/course-enrollments")
model LearnerEnrolledInCourse {
  enrollment: Enrollment;
}

@icon("/iconify/mdi/play-outline.svg")
@event("5e46046d-7d08-4357-8c98-2131a822ed51", source:"/lesson-progress")
model LessonStarted {
  lessonProgress: LessonProgress;
  progress: LearningProgress;
}

@icon("/iconify/mdi/check-circle-outline.svg")
@event("eb51e335-202d-4f82-8477-2b6053405388", source:"/lesson-progress")
model LessonCompleted {
  lessonProgress: LessonProgress;
  progress: LearningProgress;
}

@icon("/iconify/mdi/progress-check.svg")
@event("1041287c-d2fc-4f52-ac3d-5e62f20c1189", source:"/learning-progress")
model CourseProgressUpdated {
  progress: LearningProgress;
}

@icon("/iconify/mdi/trophy-outline.svg")
@event("cfb0de56-470f-4056-8c1f-0ff01d057548", source:"/course-enrollments")
model LearnerCompletedCourse {
  enrollment: Enrollment;
  progress: LearningProgress;
  completedAt: utcDateTime;
}
