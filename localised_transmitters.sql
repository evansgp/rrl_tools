-- Query ACMA RRL for local transmitters
SELECT client.LICENCEE,
  client.TRADING_NAME,
  CASE
    WHEN device_details.FREQUENCY > 1000000000 THEN CAST(device_details.FREQUENCY AS FLOAT) / 1000000000
    WHEN device_details.FREQUENCY > 1000000 THEN CAST(device_details.FREQUENCY AS FLOAT) / 1000000
    ELSE device_details.FREQUENCY
  END AS FREQUENCY,
  CASE
    WHEN device_details.FREQUENCY > 1000000000 THEN 'GHz'
    WHEN device_details.FREQUENCY > 1000000 THEN 'MHz'
    ELSE 'Hz'
  END AS UNIT,
  device_details.EIRP || device_details.EIRP_UNIT AS EIRP,
  site.NAME as SITE_NAME,
  site.LATITUDE,
  site.LONGITUDE,
  licence.LICENCE_CATEGORY_NAME,
  device_details.EMISSION,
  radio_reference_emissions.DESCRIPTION AS EMISSION_DESCRIPTION,
  'https://web.acma.gov.au/rrl//site_search.site_lookup?pSITE_ID=' || site.SITE_ID AS ACMA_SITE,
  'https://web.acma.gov.au/rrl/assignment_search.lookup?pEFL_ID=' || device_details.EFL_ID AS ACMA_FREQ,
  'https://www.google.com/maps/place/' || site.LATITUDE || ',' || site.LONGITUDE AS GOOGLE_MAP
FROM device_details
JOIN site ON device_details.SITE_ID = site.SITE_ID
JOIN licence ON licence.LICENCE_NO = device_details.LICENCE_NO
JOIN client ON client.CLIENT_NO = licence.CLIENT_NO
LEFT JOIN radio_reference_emissions ON radio_reference_emissions.EMISSION = trim(device_details.EMISSION)
WHERE site.LATITUDE BETWEEN CAST(:lat_min AS FLOAT) AND CAST(:lat_max AS FLOAT) 
AND site.LONGITUDE BETWEEN CAST(:long_min AS FLOAT) AND CAST(:long_max AS FLOAT)
AND device_details.FREQUENCY BETWEEN :freq_min_hz AND :freq_max_hz
AND device_details.DEVICE_TYPE = 'T'
AND licence.STATUS_TEXT = 'Granted'
AND licence.DATE_OF_EXPIRY > CURRENT_DATE;
