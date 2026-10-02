import "okeno-schema-markers";

@rest(Post, "/courses")
@command("f23f8543-4754-4f5a-9c54-785a84103eb1")
@icon("/iconify/mdi/book-plus-outline.svg")
model CreateCourse {
  input: {
    title: string;
    description: string;
    topics: string[];
    intendedLearners: string[];
    learningObjectives: string[];
    language: string;
    level: CourseLevel;
  };
  computed: {
  };
  output: {
    course: Course;
  };
  context: {
    instructorId: string;
  };
}

@rest(Patch, "/courses")
@command("16718107-742a-472f-8c35-b363808ddddf")
@icon("/iconify/mdi/book-edit-outline.svg")
model UpdateCourse {
  input: {
    course: Course;
  };
  computed: {
  };
  output: {
    course: Course;
  };
  context: {
    instructorId: string;
  };
}

@rest(Post, "/course-sections")
@command("31b9468e-e970-451f-88ab-5d779d44d810")
@icon("/iconify/mdi/playlist-plus.svg")
model AddSection {
  input: {
    course: Course;
    section: Section;
  };
  computed: {
  };
  output: {
    course: Course;
    section: Section;
  };
  context: {
    instructorId: string;
  };
}

@rest(Post, "/section-lessons")
@command("b41a75fb-b4e0-4de9-a0cd-3dd2d0b29996")
@icon("/iconify/mdi/play-box-plus-outline.svg")
model AddLesson {
  input: {
    section: Section;
    lesson: Lesson;
  };
  computed: {
  };
  output: {
    section: Section;
    lesson: Lesson;
  };
  context: {
    instructorId: string;
  };
}

@rest(Post, "/publish-course")
@command("0caf0fe3-0c1f-435c-9299-f7294f1b269b")
@icon("/iconify/mdi/publish.svg")
model PublishCourse {
  input: {
    course: Course;
  };
  computed: {
  };
  output: {
    course: Course;
  };
  context: {
    instructorId: string;
  };
}

@rest(Patch, "/published-courses")
@command("e391f5d6-4470-4f5d-a243-20d3a2acd5cf")
@icon("/iconify/mdi/book-refresh-outline.svg")
model UpdatePublishedCourse {
  input: {
    course: Course;
  };
  computed: {
  };
  output: {
    course: Course;
  };
  context: {
    instructorId: string;
  };
}
