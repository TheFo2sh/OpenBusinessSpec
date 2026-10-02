import "okeno-schema-markers";

@workObject("11d671a7-e4c4-495e-bc27-f460e62cd2a7")
@icon("/iconify/mdi/book-open-page-variant-outline.svg")
model CatalogCourse {
  courseId: string;
  title: string;
  subtitle?: string;
  description: string;
  instructorName: string;
  topic: string;
  level: CourseLevel;
  language: string;
  durationMinutes: int32;
  learningObjectives: string[];
  averageRating?: float32;
  reviewCount: int32;
  sections: CatalogSection[];
}

@workObject("053b3731-de51-481c-b827-69cfa9e2642c")
@icon("/iconify/mdi/view-agenda-outline.svg")
model CatalogSection {
  title: string;
  lessons: CatalogLesson[];
}

@workObject("92b9fd97-3c4e-4e2c-94c5-e140223ca86c")
@icon("/iconify/mdi/play-box-outline.svg")
model CatalogLesson {
  title: string;
  durationMinutes?: int32;
}

enum CourseLevel {
  Beginner: "beginner",
  Intermediate: "intermediate",
  Advanced: "advanced",
  AllLevels: "all_levels",
}

enum CourseSortOrder {
  Relevance: "relevance",
  HighestRated: "highest_rated",
  MostPopular: "most_popular",
  RecentlyPublished: "recently_published",
}
