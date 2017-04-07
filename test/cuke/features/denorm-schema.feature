Feature: denorm-schema

  Background:
    Given the following documents exist in the 'studentCourses' collection:
    """
    [
      {
        student: {ssn: '1', name: 'jane'},
        course: {code: 'm101', name: 'math: 101'},
        grade: 'A'
      },
      {
        student: {ssn: '2', name: 'john'},
        course: {code: 'm101', name: 'math: 101'},
        grade: 'B'
      }
    ]
    """

  Scenario: find students
    When the following aggregation steps execute on the 'studentCourses' collection:
    """
    [
      {
        $group: {
          _id: '$student.ssn',
          ssn: {$first: '$student.ssn'},
          name: {$first: '$student.name'}
        }
      },
      {
        $sort: {
          ssn: 1
        }
      }
    ]
    """
    Then the result should be like:
    """
    [
      {ssn: '1', name: 'jane'},
      {ssn: '2', name: 'john'}
    ]
    """
