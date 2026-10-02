import "okeno-schema-markers";

@rest(Post, "/course-enrollments")
@command("ac4be484-1aa9-4155-88f2-1feeaa1b6d62")
@icon("/iconify/mdi/account-plus-outline.svg")
model EnrollInCourse {
  input: {
    course: Course;
  };
  computed: {
  };
  output: {
    enrollment: Enrollment;
    progress: LearningProgress;
  };
  context: {
    learnerId: string;
  };
}

@rest(Post, "/lesson-starts")
@command("a9c828a5-dd61-4b32-b80a-ab50dc9d79a8")
@icon("/iconify/mdi/play-outline.svg")
model StartLesson {
  input: {
    enrollment: Enrollment;
    lessonId: string;
  };
  computed: {
  };
  output: {
    lessonProgress: LessonProgress;
    progress: LearningProgress;
  };
  context: {
    learnerId: string;
  };
}

@rest(Post, "/lesson-completions")
@command("001e0cb9-91d9-4fb9-adf1-3374cef50f36")
@icon("/iconify/mdi/check-circle-outline.svg")
model CompleteLesson {
  input: {
    enrollment: Enrollment;
    lessonId: string;
  };
  computed: {
  };
  output: {
    lessonProgress: LessonProgress;
    progress: LearningProgress;
  };
  context: {
    learnerId: string;
  };
}

@rest(Post, "/course-completions")
@command("4dfe6922-1e5a-415a-9cc5-6c5e78955ed2")
@icon("/iconify/mdi/trophy-outline.svg")
model CompleteCourse {
  input: {
    enrollment: Enrollment;
  };
  computed: {
  };
  output: {
    enrollment: Enrollment;
    progress: LearningProgress;
  };
  context: {
    learnerId: string;
  };
}
