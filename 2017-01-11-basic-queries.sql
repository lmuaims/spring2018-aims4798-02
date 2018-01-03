CREATE TABLE IF NOT EXISTS `course_catalog` (
  `title` VARCHAR(255) NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  `course_number` INT(4) NOT NULL,
  `section` INT(2) NOT NULL,
  `instructor` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`subject`,`course_number`,`section`)
);


INSERT INTO `course_catalog` (`title`, `subject`, `course_number`,`section`,`instructor`) VALUES
  ('Intro to Big Data and Data Science', 'AIMS', 4798, 1, 'Arin Brahma'),
  ('Developing Business Applications Using SQL', 'AIMS', 4798, 2, 'Kala Seal'),
  ('Application Development', 'AIMS', 4798, 3, 'Ying Sai'),
  ('Web-based Development', 'AIMS', 4750, 1, 'Kala Seal'),
  ('Capstone Project', 'AIMS', 4797, 1, 'Allen Gray'),
  ('Capstone Project', 'AIMS', 4797, 2, 'Allen Gray');

