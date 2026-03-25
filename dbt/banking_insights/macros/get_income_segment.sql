{% macro get_income_segment(income) %}

CASE 
    WHEN {{income}} < 30000 THEN 'Poor'
    WHEN {{income}} BETWEEN 30000 AND 50000 THEN 'Working class'
    WHEN {{income}} BETWEEN 50000 AND 100000 THEN 'Middle class'
    WHEN {{income}} BETWEEN 100000 AND 200000 THEN 'Upper-middle class'
    WHEN {{income}} BETWEEN 200000 AND 600000 THEN 'Upper class'
    WHEN {{income}} > 600000 THEN 'Wealthy'
 

END 
{% endmacro %}