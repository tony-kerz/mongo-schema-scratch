Feature: query-schema

  Background:
    Given the following documents exist in the 'students' collection:
    """
    [
      {
        ssn: '1',
        name: 'jane',
        courseRefs: [
          {
            course: {code: 'm101', name: 'math: 101'},
            grade: 'A'
          }
        ]
      },
      {
        ssn: '2',
        name: 'john',
        courseRefs: [
          {
            course: {code: 'm101', name: 'math: 101'},
            grade: 'B'
          }
        ]
      }
    ]
    """
    And the following documents exist in the 'courses' collection:
    """
    [
      {
        code: 'm101',
        name: 'math: 101',
        studentRefs: [
          {
            students: {ssn: '1', name: 'jane'},
            grade: 'A'
          },
          {
            students: {ssn: '2', name: 'john'},
            grade: 'B'
          }
        ]
      }
    ]
    """
    And the following documents exist in the 'studentCourses' collection:
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

  Scenario: find student grades
    When the following aggregation steps execute on the 'studentCourses' collection:
    """
    [
      {
        $match: {
          'course.code': 'm101'
        }
      },
      {
        $sort: {
          grade: 1
        }
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
