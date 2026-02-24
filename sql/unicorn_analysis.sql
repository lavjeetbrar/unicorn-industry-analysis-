WITH top_industries AS (
    SELECT 
        i.industry,
        COUNT(*) AS total_unicorns
    FROM industries i
    JOIN dates d
        ON i.company_id = d.company_id
    WHERE EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY i.industry
    ORDER BY total_unicorns DESC
    LIMIT 3
),
yearly_rankings AS (
    SELECT
        i.industry,
        EXTRACT(YEAR FROM d.date_joined) AS year,
        COUNT(*) AS num_unicorns,
        AVG(f.valuation) AS avg_valuation
    FROM industries i
    JOIN dates d
        ON i.company_id = d.company_id
    JOIN funding f
        ON i.company_id = f.company_id
    WHERE EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY i.industry, year
)
SELECT
    yr.industry,
    yr.year,
    yr.num_unicorns,
    ROUND(yr.avg_valuation / 1000000000, 2) AS average_valuation_billions
FROM yearly_rankings yr
JOIN top_industries ti
    ON yr.industry = ti.industry
ORDER BY yr.year DESC, yr.num_unicorns DESC;
