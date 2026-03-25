{% macro get_risk_level(ratio) %}

CASE 
    WHEN {{ratio}} > 0.05 THEN 'High risk'
    WHEN {{ratio}} > 0.01 THEN 'Medium Risk'
    ELSE 'low risk'
END

{% endmacro %}

