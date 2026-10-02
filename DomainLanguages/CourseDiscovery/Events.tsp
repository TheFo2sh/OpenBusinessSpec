import "okeno-schema-markers";

@icon("/iconify/mdi/book-search-outline.svg")
@event("a3de9be1-85c3-4387-b10f-8ae9b4ecbfd0", source:"/course-searches")
model CourseSearchPerformed {
  query?: string;
  topic?: string;
  resultCount: int32;
  learnerId?: string;
}

@icon("/iconify/mdi/book-open-page-variant-outline.svg")
@event("df7545d5-d213-4cb9-8a2b-6e2fe9de0071", source:"/course-views")
model CourseInformationViewed {
  courseId: string;
  learnerId?: string;
  viewedAt: utcDateTime;
}
