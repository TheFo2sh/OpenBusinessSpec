import "okeno-schema-markers";

@workObject("5cd63d74-c170-479a-b864-e5ca4eeaca51")
@icon("/iconify/mdi/book-edit-outline.svg")
model Course {
  title: string;
  subtitle?: string;
  description: string;
  instructorId: string;
  topics: string[];
  intendedLearners: string[];
  learningObjectives: string[];
  language: string;
  level: CourseLevel;
  status: CourseStatus;
  sections: Section[];
}

@workObject("92767f61-9196-4983-9641-2c98d11430f6")
@icon("/iconify/mdi/view-agenda-outline.svg")
model Section {
  title: string;
  description?: string;
  position: int32;
  lessons: Lesson[];
}

@workObject("c6aa27d3-cce8-441b-9b53-9487874a20ab")
@icon("/iconify/mdi/play-box-edit-outline.svg")
model Lesson {
  title: string;
  summary?: string;
  position: int32;
  format: LessonFormat;
  content: string;
  durationMinutes?: int32;
}

enum CourseLevel {
  Beginner: "beginner",
  Intermediate: "intermediate",
  Advanced: "advanced",
  AllLevels: "all_levels",
}

enum CourseStatus {
  Draft: "draft",
  Published: "published",
  Archived: "archived",
}

enum LessonFormat {
  Video: "video",
  Article: "article",
  Audio: "audio",
  Exercise: "exercise",
  Other: "other",
}
