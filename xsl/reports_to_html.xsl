<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="statusFilter" select="''"/>
  <xsl:param name="search" select="''"/>
  <xsl:param name="groupBy" select="''"/>
  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Reports - Time Tracker</title>
        <style>
          table { border-collapse: collapse; width: 100%; }
          th, td { border: 1px solid #ccc; padding: 6px; }
        </style>
      </head>
      <body>
        <h2>Отчёты по времени</h2>
        <table>
          <tr>
            <th>ID</th><th>Пользователь</th><th>Роль</th>
            <th>Статус</th><th>Часы</th><th>Дата входа</th>
          </tr>

          <xsl:for-each select="/reports/report[
             (string($statusFilter) = '' or @kinnitusstaatus = $statusFilter)
             and (string($search) = '' or contains(kasutaja/nimi, $search) or contains(kasutaja/perekonnanimi, $search))
          ]">
            <tr>
              <td><xsl:value-of select="@aruandeId"/></td>
              <td><xsl:value-of select="concat(kasutaja/nimi, ' ', kasutaja/perekonnanimi)"/></td>
              <td><xsl:value-of select="kasutaja/@roll"/></td>
              <td><xsl:value-of select="@kinnitusstaatus"/></td>
              <td><xsl:value-of select="format-number(sum(.//hours), '#0.00')"/></td>
              <td><xsl:value-of select="@sisselogimisaeg"/></td>
            </tr>
          </xsl:for-each>
        </table>

        <p><strong>Фильтр:</strong> <xsl:value-of select="$statusFilter"/></p>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
