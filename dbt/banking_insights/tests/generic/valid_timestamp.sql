{% test valid_timestamp(model,column_name)%}

select 
    *
from {{model}}
where {{column_name}} > current_timestamp() or {{column_name}} < '1940-01-01'



{% endtest%}