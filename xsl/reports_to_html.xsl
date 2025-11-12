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
          body { font-family: Arial, sans-serif; margin: 30px; }
          table { border-collapse: collapse; width: 100%; }
          th, td { border: 1px solid #ccc; padding: 6px; text-align: left; }
          form { margin-bottom: 20px; }
          label { margin-right: 10px; }
          input[type=text], input[type=number], select { padding: 4px; margin: 4px; }
          button { padding: 4px 8px; margin-left: 5px; cursor: pointer; }
          .delete-btn {
            background-color: #d9534f;
            color: white;
            border: none;
            border-radius: 4px;
          }
          .delete-btn:hover { background-color: #c9302c; }
          .add-form { margin-top: 30px; border: 1px solid #ccc; padding: 15px; border-radius: 8px; background: #f9f9f9; }
        </style>
      </head>
      <body>
        <h2>Aruanded aja järgi</h2>

        <form method="get" action="">
            <label>Staatus:
                <select name="statusFilter">
                    <option value="">Kõik</option>
                    <option value="pending">
                        <xsl:if test="$statusFilter='pending'">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        Pending
                    </option>
                    <option value="confirmed">
                        <xsl:if test="$statusFilter='confirmed'">
                            <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        Confirmed
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
            <th>ID</th>
            <th>Kasutaja</th>
            <th>Roll</th>
            <th>Staatus</th>
            <th>Kellad</th>
            <th>Sisenemise kuupäev</th>
            <th>Toiming</th>
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
              <td>
                <form method="get" action="../php/delete_report.php" onsubmit="return confirm('Kas soovid kustutada selle aruande?');">
                  <input type="hidden" name="aruandeId">
                    <xsl:attribute name="value">
                      <xsl:value-of select="@aruandeId"/>
                    </xsl:attribute>
                  </input>
                  <button type="submit" class="delete-btn">Kustuta</button>
                </form>
              </td>
            </tr>
          </xsl:for-each>
        </table>

        <div class="add-form">
          <h3>Lisa uus aruanne</h3>
          <form method="post" action="../php/add_report.php">
            <label>ID:
              <input type="text" name="aruandeId" required="required"/>
            </label>
            <label>Nimi:
              <input type="text" name="nimi" required="required"/>
            </label>
            <label>Perekonnanimi:
              <input type="text" name="perekonnanimi" required="required"/>
            </label>
            <label>Roll:
              <input type="text" name="roll" required="required"/>
            </label>
            <label>Tunnid:
              <input type="number" name="hours" step="0.1" required="required"/>
            </label>
            <label>Staatus:
              <select name="kinnitusstaatus">
                <option value="pending">Pending</option>
                <option value="confirmed">Confirmed</option>
              </select>
            </label>
            <button type="submit">Lisa aruanne</button>
          </form>
        </div>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
