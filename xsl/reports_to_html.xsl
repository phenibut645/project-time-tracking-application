<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="page" select="'reports'"/>
    <xsl:param name="statusFilter" select="''"/>
    <xsl:param name="search" select="''"/>
    <xsl:output method="html" encoding="utf-8" indent="yes"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>Time Tracker</title>
                <meta charset="utf-8"/>
                <style>
                    body {
                    font-family: Inter, Arial, sans-serif;
                    margin: 24px;
                    background: #f5f7fa;
                    color: #2d3a4b;
                    }

                    .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    }

                    /* Заголовок */
                    header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 28px;
                    }

                    h1 {
                    font-size: 26px;
                    font-weight: 600;
                    margin: 0;
                    }

                    /* Навигация */
                    nav a {
                    margin-right: 14px;
                    text-decoration: none;
                    padding: 8px 14px;
                    border-radius: 8px;
                    background: #ffffff;
                    color: #2d3a4b;
                    border: 1px solid #dfe6ee;
                    transition: .15s ease-in-out;
                    }

                    nav a:hover {
                    background: #eef2f6;
                    }

                    nav a.active {
                    background: #2d3a4b;
                    color: #fff;
                    }

                    /* Карточки */
                    .card {
                    background: #ffffff;
                    padding: 20px;
                    border-radius: 12px;
                    border: 1px solid #e3e8ef;
                    box-shadow: 0 2px 8px rgba(0, 0, 0, .04);
                    margin-bottom: 22px;
                    }

                    /* Таблицы */
                    table {
                    width: 100%;
                    border-collapse: collapse;
                    }

                    th {
                    background: #f0f3f7;
                    font-weight: 600;
                    padding: 10px;
                    font-size: 14px;
                    border-bottom: 1px solid #d9e1ea;
                    }

                    td {
                    padding: 8px 10px;
                    border-bottom: 1px solid #eef1f4;
                    font-size: 14px;
                    }

                    tr:hover td {
                    background: #fafbfd;
                    }

                    .muted {
                    color: #7e8b99;
                    font-size: 12px;
                    }

                    /* Кнопки */
                    .btn {
                    padding: 6px 12px;
                    border-radius: 6px;
                    border: none;
                    cursor: pointer;
                    font-size: 13px;
                    }

                    .btn-primary {
                    background: #2f6fed;
                    color: #fff;
                    }

                    .btn-danger {
                    background: #e04545;
                    color: #fff;
                    }

                    .btn:hover {
                    opacity: .85;
                    }

                    /* Формы */
                    .form-row {
                    display: flex;
                    gap: 10px;
                    flex-wrap: wrap;
                    margin-bottom: 12px;
                    align-items: center;
                    }

                    input[type=text], input[type=number], select, input[type=email], input[type=date] {
                    padding: 7px 10px;
                    border-radius: 6px;
                    border: 1px solid #cfd8e3;
                    font-size: 14px;
                    }

                    /* Капсулы */
                    .pill {
                    padding: 6px 12px;
                    border-radius: 999px;
                    background: #eef4ff;
                    color: #2d3a4b;
                    font-size: 13px;
                    }

                    /* Заголовки внутри projects */
                    h3 {
                    margin-top: 26px;
                    margin-bottom: 10px;
                    }

                    /* Увеличенный отступ между проектами */
                    .card h3 {
                    margin-top: 32px;
                    }

                </style>
            </head>
            <body>
                <div class="container">
                    <header>
                        <h1>Time Tracker</h1>
                        <div class="summary">
                            <div class="pill">Reports: <xsl:value-of select="count(/database/reports/report)"/></div>
                            <div class="pill">Users: <xsl:value-of select="count(/database/users/user)"/></div>
                        </div>
                    </header>

                    <nav class="card">
                        <xsl:variable name="p" select="$page"/>
                        <a href="transform.php?page=reports">
                            <xsl:if test="$p='reports'"><span class="active">Reports</span></xsl:if>
                            <xsl:if test="$p!='reports'">Reports</xsl:if>
                        </a>
                        <a href="transform.php?page=users">
                            <xsl:if test="$p='users'"><span class="active">Users</span></xsl:if>
                            <xsl:if test="$p!='users'">Users</xsl:if>
                        </a>
                        <a href="transform.php?page=statuses">
                            <xsl:if test="$p='statuses'"><span class="active">Statuses</span></xsl:if>
                            <xsl:if test="$p!='statuses'">Statuses</xsl:if>
                        </a>
                        <a href="transform.php?page=roles">
                            <xsl:if test="$p='roles'"><span class="active">Roles</span></xsl:if>
                            <xsl:if test="$p!='roles'">Roles</xsl:if>
                        </a>
                        <a href="transform.php?page=projects">
                            <xsl:if test="$p='projects'"><span class="active">Projects</span></xsl:if>
                            <xsl:if test="$p!='projects'">Projects</xsl:if>
                        </a>
                        <a href="transform.php?page=add">Add</a>
                        <a href="../php/export_json.php" style="float:right;">Download JSON</a>
                    </nav>

                    <xsl:if test="$page='reports'">
                        <div class="card">
                            <h2>Reports</h2>
                            <form method="get" action="transform.php">
                                <input type="hidden" name="page" value="reports"/>
                                <div class="form-row">
<!--                                    <label>Filter by status:-->
<!--                                        <select name="statusFilter">-->
<!--                                            <option value="">All</option>-->
<!--                                            <xsl:for-each select="/database/statuses/status">-->
<!--                                                <option value="{@id}">-->
<!--                                                    <xsl:value-of select="."/>-->
<!--                                                </option>-->
<!--                                            </xsl:for-each>-->
<!--                                        </select>-->
<!--                                    </label>-->

<!--                                    <label>Search user:-->
<!--                                        <input type="text" name="search" value="{$search}"/>-->
<!--                                    </label>-->

<!--                                    <button class="btn btn-primary" type="submit">Filter</button>-->
                                </div>
                            </form>

                            <table>
                                <tr>
                                    <th>ID</th>
                                    <th>User</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Total Hours</th>
                                    <th>Created</th>
                                    <th>Department</th>
                                    <th>Actions</th>
                                </tr>

                                <xsl:for-each select="/database/reports/report[
                                    (not($statusFilter) or @statusRef = $statusFilter)
                                    and
                                    (not($search) or contains(string(/database/users/user[@id=current()/@userRef]/firstName), $search) or contains(string(/database/users/user[@id=current()/@userRef]/lastName), $search))
                                ]">
                                    <tr>
                                        <td><xsl:value-of select="@id"/></td>
                                        <td>
                                            <xsl:value-of select="concat(/database/users/user[@id=current()/@userRef]/firstName, ' ', /database/users/user[@id=current()/@userRef]/lastName)"/>
                                            <div class="muted">(<xsl:value-of select="/database/users/user[@id=current()/@userRef]/login"/>)</div>
                                        </td>
                                        <td><xsl:value-of select="/database/roles/role[@id=/database/users/user[@id=current()/@userRef]/@roleRef]"/></td>
                                        <td><xsl:value-of select="/database/statuses/status[@id=current()/@statusRef]"/></td>
                                        <td>
                                            <xsl:value-of select="format-number(sum(entries/entry/hours), '#0.00')"/>
                                        </td>
                                        <td><xsl:value-of select="@created"/></td>
                                        <td><xsl:value-of select="/database/departments/department[@id=current()/@departmentRef]"/></td>
                                        <td class="actions">
                                            <form method="post" action="../php/admin_actions.php">
                                                <input type="hidden" name="aruandeId" value="{@id}"/>
                                                <button class="btn" type="submit" name="action" value="approve">Approve</button>
                                                <button class="btn" type="submit" name="action" value="reject">Reject</button>
                                            </form>

                                            <form method="post" action="../php/delete_report.php" onsubmit="return confirm('Delete report?');">
                                                <input type="hidden" name="aruandeId" value="{@id}"/>
                                                <button class="btn btn-danger" type="submit">Delete</button>
                                            </form>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="8">
                                            <strong>Entries:</strong>
                                            <table>
                                                <tr><th>Project</th><th>Feature</th><th>Task</th><th>Hours</th><th>Date</th><th>Comment</th></tr>
                                                <xsl:for-each select="entries/entry">
                                                    <tr>
                                                        <td><xsl:value-of select="/database/projects/project[@id=current()/@projectRef]/@name"/></td>
                                                        <td><xsl:value-of select="/database/projects/project/feature[@id=current()/@featureRef]/@name"/></td>
                                                        <td><xsl:value-of select="/database/projects/project/feature/task[@id=current()/@taskRef]/@name"/></td>
                                                        <td><xsl:value-of select="hours"/></td>
                                                        <td><xsl:value-of select="date"/></td>
                                                        <td><xsl:value-of select="comment"/></td>
                                                    </tr>
                                                </xsl:for-each>
                                            </table>
                                        </td>
                                    </tr>

                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:if>

                    <xsl:if test="$page='users'">
                        <div class="card">
                            <h2>Users</h2>
                            <table>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Login</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Work hours</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>

                                <xsl:for-each select="/database/users/user">
                                    <tr>
                                        <td><xsl:value-of select="@id"/></td>
                                        <td><xsl:value-of select="concat(firstName,' ',lastName)"/></td>
                                        <td><xsl:value-of select="login"/></td>
                                        <td><xsl:value-of select="email"/></td>
                                        <td><xsl:value-of select="phone"/></td>
                                        <td><xsl:value-of select="workHours"/></td>
                                        <td><xsl:value-of select="/database/roles/role[@id=current()/@roleRef]"/></td>
                                        <td><a href="../php/delete.php?type=user&amp;id={@id}"
                                               class="btn btn-danger"
                                               onclick="return confirm('Delete user?');">
                                            Delete
                                        </a></td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:if>

                    <xsl:if test="$page='statuses'">
                        <div class="card">
                            <h2>Statuses</h2>
                            <table>
                                <tr><th>ID</th><th>Label</th><th>Actions</th></tr>

                                <xsl:for-each select="/database/statuses/status">
                                    <tr><td><xsl:value-of select="@id"/></td><td><xsl:value-of select="."/></td>
                                    <td>
                                        <a class="btn btn-danger"
                                           href="../php/delete.php?type=status&amp;id={@id}"
                                           onclick="return confirm('Delete status?');">Delete</a>
                                    </td></tr>
                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:if>

                    <xsl:if test="$page='roles'">
                        <div class="card">
                            <h2>Roles</h2>
                            <table>
                                <tr><th>ID</th><th>Role</th><th>Actions</th></tr>

                                <xsl:for-each select="/database/roles/role">
                                    <tr><td><xsl:value-of select="@id"/></td><td><xsl:value-of select="."/></td>
                                    <td> <a class="btn btn-danger"
                                            href="../php/delete.php?type=role&amp;id={@id}"
                                            onclick="return confirm('Delete role?');">Delete</a></td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </div>
                    </xsl:if>

                    <xsl:if test="$page='projects'">
                        <div class="card">
                            <h2>Projects / Features / Tasks</h2>
                            <xsl:for-each select="/database/projects/project">
                                <h3>
                                    <xsl:value-of select="@name"/> (<xsl:value-of select="@id"/>)

                                    <a class="btn btn-danger"
                                       style="margin-left:10px;font-size:12px;padding:3px 8px;"
                                       href="../php/delete.php?type=project&amp;id={@id}"
                                       onclick="return confirm('Delete project and all nested data?');">
                                        Delete
                                    </a>
                                </h3>

                                <table>
                                    <tr><th>Feature</th><th>Tasks</th></tr>
                                    <xsl:for-each select="feature">
                                        <tr>
                                            <td><xsl:value-of select="@name"/> (<xsl:value-of select="@id"/>)</td>
                                            <td>
                                                <xsl:for-each select="task">
                                                    <div><xsl:value-of select="@name"/> (<xsl:value-of select="@id"/>)</div>
                                                </xsl:for-each>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </table>
                            </xsl:for-each>
                        </div>
                    </xsl:if>

                    <xsl:if test="$page='add'">
                        <div class="card">
                            <h2>Add new</h2>

                            <h3>Add user</h3>
                            <form method="post" action="../php/add_user.php" class="card">
                                <div class="form-row">
                                    <input type="text" name="firstName" placeholder="First name" required="required"/>
                                    <input type="text" name="lastName" placeholder="Last name" required="required"/>
                                    <input type="text" name="login" placeholder="Login" required="required"/>
                                    <input type="email" name="email" placeholder="Email"/>
                                    <input type="text" name="phone" placeholder="Phone"/>
                                    <input type="number" name="workHours" placeholder="Work hours" step="0.5"/>
                                    <label>Role:
                                        <select name="roleRef">
                                            <xsl:for-each select="/database/roles/role">
                                                <option value="{@id}"><xsl:value-of select="."/></option>
                                            </xsl:for-each>
                                        </select>
                                    </label>
                                    <button class="btn btn-primary" type="submit">Add User</button>
                                </div>
                            </form>

                            <h3>Add role</h3>
                            <form method="post" action="../php/add_role.php" class="card">
                                <div class="form-row">
                                    <input type="text" name="roleName" placeholder="Role name" required="required"/>
                                    <button class="btn btn-primary" type="submit">Add Role</button>
                                </div>
                            </form>

                            <h3>Add status</h3>
                            <form method="post" action="../php/add_status.php" class="card">
                                <div class="form-row">
                                    <input type="text" name="statusName" placeholder="Status name" required="required"/>
                                    <button class="btn btn-primary" type="submit">Add Status</button>
                                </div>
                            </form>

                            <h3>Add project / feature / task</h3>
                            <form method="post" action="../php/add_project.php" class="card">
                                <div class="form-row">
                                    <input type="text" name="projectName" placeholder="Project name" required="required"/>
                                    <input type="text" name="featureName" placeholder="Feature name" required="required"/>
                                    <input type="text" name="taskName" placeholder="Task name" required="required"/>
                                    <button class="btn btn-primary" type="submit">Add Project/Feature/Task</button>
                                </div>
                            </form>

                            <h3>Add report</h3>
                            <form method="post" action="../php/add_report.php" class="card">
                                <div class="form-row">
                                    <input type="text" name="reportId" placeholder="Report ID (e.g. R-003)" required="required"/>
                                    <label>User:
                                        <select name="userRef">
                                            <xsl:for-each select="/database/users/user">
                                                <option value="{@id}"><xsl:value-of select="concat(firstName,' ',lastName)"/></option>
                                            </xsl:for-each>
                                        </select>
                                    </label>
                                    <label>Status:
                                        <select name="statusRef">
                                            <xsl:for-each select="/database/statuses/status">
                                                <option value="{@id}"><xsl:value-of select="."/></option>
                                            </xsl:for-each>
                                        </select>
                                    </label>
                                    <label>Department:
                                        <select name="departmentRef">
                                            <xsl:for-each select="/database/departments/department">
                                                <option value="{@id}"><xsl:value-of select="."/></option>
                                            </xsl:for-each>
                                        </select>
                                    </label>
                                </div>

                                <div class="form-row">
                                    <label>Project:
                                        <select name="projectRef">
                                            <xsl:for-each select="/database/projects/project">
                                                <option value="{@id}"><xsl:value-of select="@name"/></option>
                                            </xsl:for-each>
                                        </select>
                                    </label>
                                    <label>Feature ID:
                                        <input type="text" name="featureRef" placeholder="feature id (f1) or leave blank"/>
                                    </label>
                                    <label>Task ID:
                                        <input type="text" name="taskRef" placeholder="task id (t1) or leave blank"/>
                                    </label>
                                    <input type="number" step="0.1" name="hours" placeholder="Hours" required="required"/>
                                    <input type="date" name="date" value="{$currentDate }"/>
                                    <input type="text" name="comment" placeholder="Comment"/>
                                    <button class="btn btn-primary" type="submit">Add Report</button>
                                </div>
                            </form>

                        </div>
                    </xsl:if>

                </div>
            </body>
        </html>
    </xsl:template>


    <xsl:template name="current-date">
        <xsl:text>2025-11-12</xsl:text>
    </xsl:template>

</xsl:stylesheet>
