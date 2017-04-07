Feature: lookup-schema

  Background:
    Given the following documents exist in the 'courses' collection:
    """
    [
      {code: 'e101', name: 'english: 101'},
      {code: 'm101', name: 'math: 101'}
    ]
    """
    And the following documents exist in the 'students' collection:
    """
    [
      {ssn: '1', name: 'jane'},
      {ssn: '2', name: 'john'}
    ]
    """
    And the following documents exist in the 'studentCourses' collection:
    """
    [
      {studentSsn: '1', courseCode: 'm101', grade: 'A'},
      {studentSsn: '2', courseCode: 'm101', grade: 'B'},
    ]
    """

  Scenario: find student grades
    When the following aggregation steps execute on the 'studentCourses' collection:
    """
    [
      {
        $lookup: {
          from: 'students',
          localField: 'studentSsn',
          foreignField: 'ssn',
          as: 'student'
        }
      },
      {
        $unwind: '$student'
      },
      {
        $lookup: {
          from: 'courses',
          localField: 'courseCode',
          foreignField: 'code',
          as: 'course'
        }
      },
      {
        $unwind: '$course'
      }

    ]
    """
    Then the result should be like:
    """
    [
      {student: {name: 'jane'}, course: {name: 'math: 101'}, grade: 'A'},
      {student: {name: 'john'}, course: {name: 'math: 101'}, grade: 'B'}
    ]
    """
