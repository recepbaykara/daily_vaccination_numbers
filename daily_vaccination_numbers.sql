WITH MedianDailyVaccinations AS (
    SELECT 
        country,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY daily_vaccination) AS median_vaccination
    FROM 
        country_vaccination_stats
    WHERE 
        daily_vaccination IS NOT NULL
    GROUP BY 
        country
),
FilledDailyVaccinations AS (
    SELECT 
        cvs.country,
        cvs.date,
        COALESCE(cvs.daily_vaccination, mdv.median_vaccination, 0) AS daily_vaccination,
        cvs.vaccines
    FROM 
        country_vaccination_stats cvs
    LEFT JOIN 
        MedianDailyVaccinations mdv
    ON 
        cvs.country = mdv.country
)
SELECT 
    * 
FROM 
    FilledDailyVaccinations;
