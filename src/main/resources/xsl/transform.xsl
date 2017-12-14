<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://makar.ru/icss/labs/xsd">

    <xsl:template name="groupRow">
        <xsl:param name="id"/>
        <xsl:param name="name"/>
        <xsl:param name="department"/>
        <xsl:param name="baseCost"/>
        <xsl:param name="cost"/>

        <tr>
            <td>
                <xsl:value-of select="$id"/>
            </td>
            <td>
                <xsl:value-of select="$name"/>
            </td>
            <td>
                <xsl:value-of select="$department"/>
            </td>
            <td>
                <xsl:value-of select="$baseCost"/>
            </td>
            <td>
                <xsl:value-of select="$cost"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="studentRow">
        <xsl:param name="lastName"/>
        <xsl:param name="firstName"/>
        <xsl:param name="patronymic" required="no"/>
        <xsl:param name="birthDate"/>
        <xsl:param name="onBudget" required="no"/>
        <xsl:param name="groupRef"/>

        <tr>
            <td>
                <xsl:value-of select="$lastName"/>
            </td>
            <td>
                <xsl:value-of select="$firstName"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$patronymic">
                        <xsl:value-of select="$patronymic"/>
                    </xsl:when>
                    <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:value-of select="$birthDate"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$onBudget">✓</xsl:when>
                    <xsl:otherwise>✘</xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:value-of select="$groupRef"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="groupsCount" select="count(t:info/t:groups/t:group)"/>
        <xsl:variable name="studentsCount" select="count(t:info/t:students/t:student)"/>
        <html lang="ru">
            <head>
                <title>Отчет по группам и студентам</title>
                <style>
                    body {
                    margin: 0;
                    padding: 0;
                    font-family: Verdana, serif;
                    font-size: 1.2em;
                    }

                    .content {
                    width: 80%;
                    margin: 15px auto;
                    }

                    .groups table, .students table {
                    border-collapse: collapse;
                    width: 90%;
                    text-align: center;
                    }

                    .groups table tr th,
                    .groups table tr td,
                    .students table tr th,
                    .students table tr td {
                    padding: 3px;
                    border: 1px solid black;
                    }

                    .groups table tr:nth-child(2n) td,
                    .students table tr:nth-child(2n) td {
                    background-color: #ededed;
                    }
                </style>
            </head>
            <body>
                <div class="content">
                    <h1>Отчет по группам и студентам</h1>
                    <hr/>
                    <div class="groups">
                        <h2>Группы</h2>
                        <table>
                            <tr>
                                <th>№</th>
                                <th>Название</th>
                                <th>Институт</th>
                                <th>Базовая стоимость, ₽</th>
                                <th>Стоимость обучения, ₽</th>
                            </tr>
                            <xsl:for-each select="t:info/t:groups/t:group">
                                <xsl:call-template name="groupRow">
                                    <xsl:with-param name="id" select="@id"/>
                                    <xsl:with-param name="name" select="t:name"/>
                                    <xsl:with-param name="department" select="t:department"/>
                                    <xsl:with-param name="baseCost" select="t:baseCost"/>
                                    <xsl:with-param name="cost" select="t:baseCost * $studentsCount"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <tr>
                                <td colspan="5">
                                    Всего групп:
                                    <xsl:copy-of select="$groupsCount"/>
                                </td>
                            </tr>
                        </table>
                    </div>

                    <div class="students">
                        <h2>Студенты</h2>
                        <table>
                            <tr>
                                <th>Фамилия</th>
                                <th>Имя</th>
                                <th>Отчество</th>
                                <th>Дата рождения</th>
                                <th>На бютжете</th>
                                <th>Номер группы</th>
                            </tr>
                            <xsl:for-each select="t:info/t:students/t:student">
                                <xsl:sort select="t:lastName"/>
                                <xsl:call-template name="studentRow">
                                    <xsl:with-param name="lastName" select="t:lastName"/>
                                    <xsl:with-param name="firstName" select="t:firstName"/>
                                    <xsl:with-param name="patronymic" select="t:patronymic"/>
                                    <xsl:with-param name="birthDate" select="t:birthDate"/>
                                    <xsl:with-param name="onBudget" select="t:onBudget"/>
                                    <xsl:with-param name="groupRef" select="t:groupRef"/>
                                </xsl:call-template>
                            </xsl:for-each>
                            <tr>
                                <td colspan="6">
                                    Всего студентов:
                                    <xsl:copy-of select="$studentsCount"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>