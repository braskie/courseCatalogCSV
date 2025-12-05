with children as (

select distinct
    c1.number course1number
    ,pr.[type]
    ,c2.number course2number
from CoursePrerequisite pr --planning rules
    inner join course c1 on c1.courseid = pr.courseid
    inner join Calendar cal on cal.calendarID = c1.calendarID
    inner join School s on s.schoolID = cal.schoolID
    inner join course c2 on c2.courseid = pr.courseid2
where
        cal.endYear = 2027
    and cal.schoolID in (11,21)
    and pr.[type] in ('PO','CO')
)
, grade_level AS (
select distinct
    c1.number course_number
    ,CONCAT('[',transcriptCourseNumberString,']') as grade_level
from CoursePrerequisite pr
    inner join course c1 on c1.courseid = pr.courseid
    inner join Calendar cal on cal.calendarID = c1.calendarID
    inner join School s on s.schoolID = cal.schoolID
WHERE
    cal.endYear = 2027
    and cal.schoolID in (11,21)
    and pr.[type] in ('GL')
)
, credits AS (
select distinct
    c1.number course_number
    ,gt.credit
from v_CourseGradingTask gt
    inner join course c1 on c1.courseid = gt.courseid
    inner join Calendar cal on cal.calendarID = c1.calendarID
    inner join School s on s.schoolID = cal.schoolID
    where
        cal.endYear = 2027
    and cal.schoolID in (11,21)
    --and gt.transcript = 1
    and gt.name = 'Semester Grade'
)
, prereqs AS (
select distinct
    c1.number course_number
    ,CONCAT('[',transcriptCourseNumberString,']') prereqs
from CoursePrerequisite pr
    inner join course c1 on c1.courseid = pr.courseid
    inner join Calendar cal on cal.calendarID = c1.calendarID
    inner join School s on s.schoolID = cal.schoolID
    where
        cal.endYear = 2027
    and cal.schoolID in (11,21)
    and pr.[type] in ('P','PC')
)


select
    number number
    ,ISNULL(co.course2number, '') child
    ,name name
    ,[description] as description
    ,department
    ,[repeatable]
    ,FORMAT(ISNULL(cr1.credit, 0) + ISNULL(cr2.credit, 0), '0.0###') credits --check this math. It probabl isn't the best way to do this
    ,isnull(gl.grade_level, '') req_gradelevel
    ,isnull(pr.prereqs, '') req_prereq
    ,'' duration
    ,requestable
    ,case cm.type when 'R' then 'Required' when 'E' then 'Elective' else 'UnknownType'end [required]
    ,isnull(honorsCode, '') honors
from coursemaster cm
    left join children co on co.course1number = cm.number and co.[type] = 'PO'
    left join children po on po.course1number = cm.number and po.[type] = 'CO'
    left join grade_level gl on gl.course_number = cm.number
    left join prereqs pr on pr.course_number = cm.number
    left join credits cr1 on cr1.course_number = cm.number
    left join credits cr2 on cr2.course_number = co.course2number
where
        active = 1
    and catalogid = 1
    and po.course2number is null --remove courses with a parent
    and department in (
        'Academies'
        ,'Agriscience'
        ,'Art'
        ,'Business'
        ,'Computer and Information Science'
        ,'English'
        ,'Family and Consumer Science'
        ,'Health'
        ,'Mathematics'
        ,'Music'
        ,'Physical Education'
        ,'Science'
        ,'Social Studies'
        ,'Technology and Engineering Education'
        ,'World Languages'
        ,'Youth Apprentice'
    )
    and number not like '%/%'
    and requestable = 1
FOR JSON PATH