{% macro get_day(jour)%}
    
CASE 
    WHEN {{jour}} in ('Sat','Sun') THEN 'weekend'
    ELSE 'businessday'
END 


{%endmacro%}