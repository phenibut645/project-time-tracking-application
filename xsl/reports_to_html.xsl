<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="statusFilter" select="''"/>
  <xsl:param name="search" select="''"/>
  <xsl:output method="html" encoding="utf-8" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Reports - Time Tracker</title>
        <style>
          table { border-collapse: collapse; width: 100%; }
          th, td { border: 1px solid #ccc; padding: 6px; }
          form { margin-bottom: 20px; }
          label { margin-right: 10px; }
          input[type=text] { padding: 4px; }
          select { padding: 4px; }
          button { padding: 4px 8px; margin-left: 5px; }
        </style>
      </head>
      <body>
        <h2>Aruanded aja järgi</h2>

        <form method="get" action="">
            <label>Staatus:
                <select name="statusFilter">
                <option value="">
                    <xsl:if test="$statusFilter=''">Kõik</xsl:if>
                </option>
                <option value="pending">
                    <xsl:if test="$statusFilter='pending'">Pending</xsl:if>
                </option>
                <option value="confirmed">
                    <xsl:if test="$statusFilter='confirmed'">Confirmed</xsl:if>
                </option>
                </select>
            </label>

            <label>Otsi kasutaja järgi:
                <input type="text" name="search">
                <xsl:attribute name="value">
                    <xsl:value-of select="$search"/>
                </xsl:attribute>
                </input>
            </label>

            <button type="submit">Filter</button>
        </form>


        <table>
          <tr>
            <th>ID</th><th>Kasutaja</th><th>Roll</th>
            <th>Staatus</th><th>Kellad</th><th>Sisenemise kuupäev</th>
          </tr>

          <xsl:for-each select="/reports/report[
             (not($statusFilter) or @kinnitusstaatus = $statusFilter)
             and (not($search) or contains(kasutaja/nimi, $search) or contains(kasutaja/perekonnanimi, $search))
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

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
