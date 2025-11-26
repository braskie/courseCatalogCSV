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


select
    number course_number
    ,ISNULL(co.course2number, '') child
    ,name course_name
    ,sunprairie_custom.dbo.udf_StripHTML([description]) as course_description
    ,department
    ,[repeatable]
    ,'' credits
    ,isnull(gl.grade_level, '') grade_level
    ,'' CoursePrerequisite
    ,'' duration
    ,requestable
    ,cm.type [required]
    ,isnull(honorsCode, '') honors
from coursemaster cm
    left join children co on co.course1number = cm.number and co.[type] = 'PO'
    left join children po on po.course1number = cm.number and po.[type] = 'CO'
    left join grade_level gl on gl.course_number = cm.number
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

