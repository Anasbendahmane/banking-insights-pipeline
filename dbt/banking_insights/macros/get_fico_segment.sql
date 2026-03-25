{% macro get_fico_segment(fico_score)%}

CASE 
    WHEN {{fico_score}} BETWEEN 300 and 579 THEN 'Poor'
    WHEN {{fico_score}} BETWEEN 580 and 669 THEN 'Fair'
    WHEN {{fico_score}} BETWEEN 670 and 739 THEN 'Good'
    WHEN {{fico_score}} BETWEEN 740 and 799 THEN 'Very good'
    WHEN {{fico_score}} BETWEEN 800 and 850 THEN 'Excellent'
    ELSE 'Unkown'

END 

{% endmacro%}