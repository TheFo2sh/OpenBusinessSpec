import "okeno-schema-markers";

@icon("/iconify/mdi/book-plus-outline.svg")
@event("7c74bfc1-f16f-4361-ad6a-89a6369baf99", source:"/courses")
model CourseCreated {
  course: Course;
}

@icon("/iconify/mdi/book-edit-outline.svg")
@event("1c51178e-bdd3-468c-bdb9-983f164a97d3", source:"/courses")
model CourseUpdated {
  course: Course;
}

@icon("/iconify/mdi/playlist-plus.svg")
@event("33806d4e-ca29-450a-893b-08f8f9cdbff5", source:"/course-sections")
model SectionAdded {
  course: Course;
  section: Section;
}

@icon("/iconify/mdi/play-box-plus-outline.svg")
@event("efa6e1ff-bdab-4074-8de0-fc606d6e3824", source:"/section-lessons")
model LessonAdded {
  course: Course;
  section: Section;
  lesson: Lesson;
}

@icon("/iconify/mdi/publish.svg")
@event("78314681-ee1f-4ba8-97b1-e1fa9650eb1f", source:"/courses")
model CoursePublished {
  course: Course;
  publishedAt: utcDateTime;
}

@icon("/iconify/mdi/book-refresh-outline.svg")
@event("9e3cea0f-f32c-482d-978a-571da88db5d0", source:"/courses")
model PublishedCourseUpdated {
  course: Course;
  updatedAt: utcDateTime;
}
