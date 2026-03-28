{% macro saison(mois)%}

    CASE 
        WHEN {{mois}} in (12,1,2) THEN 'winter'
        WHEN {{mois}} in (3,4,5) THEN 'spring'
        WHEN {{mois}} in (6,7,8) THEN 'summer'
        ELSE 'autumn'

    END

{%endmacro %}