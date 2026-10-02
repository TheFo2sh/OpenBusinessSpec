import "okeno-schema-markers";

@rest(Get, "/courses")
@command("dad7ec7f-31f5-469e-8802-0dbbe1bebaa5")
@icon("/iconify/mdi/book-search-outline.svg")
model SearchCourses {
  input: {
    query?: string;
    topic?: string;
    level?: CourseLevel;
    language?: string;
    sortOrder?: CourseSortOrder;
  };
  computed: {
  };
  output: {
    courses: CatalogCourse[];
  };
  context: {
    learnerId?: string;
  };
}

@rest(Get, "/course-information")
@command("045606fd-2cd2-463b-9670-d2ea708c6970")
@icon("/iconify/mdi/book-open-page-variant-outline.svg")
model ViewCourseInformation {
  input: {
    courseId: string;
  };
  computed: {
  };
  output: {
    course: CatalogCourse;
  };
  context: {
    learnerId?: string;
  };
}
