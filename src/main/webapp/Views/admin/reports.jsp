<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/admin/reports.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Reports — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">

        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Financial Reports</h1>
            <p class="text-gray-500 text-sm mt-0.5">Summary of cooperative financial performance</p>
        </div>

        <div class="mb-6 rounded-xl border border-gray-200 bg-white p-4">
            <form action="${pageContext.request.contextPath}/admin" method="get" class="flex flex-wrap items-end gap-3">
                <input type="hidden" name="page" value="reports">
                <div>
                    <label class="block text-xs font-semibold uppercase tracking-wide text-gray-500 mb-1">Recovery period</label>
                    <select name="period" class="rounded-lg border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                        <option value="all" ${selectedPeriod == 'all' ? 'selected' : ''}>All time</option>
                        <option value="month" ${selectedPeriod == 'month' ? 'selected' : ''}>This month</option>
                        <option value="6m" ${selectedPeriod == '6m' ? 'selected' : ''}>Last 6 months</option>
                    </select>
                </div>
                <button type="submit" class="inline-flex items-center rounded-lg bg-gray-800 px-4 py-2 text-sm font-semibold text-white hover:bg-gray-900 transition">
                    Apply Filter
                </button>
            </form>
        </div>

        <div class="mb-6 flex flex-wrap items-center gap-3">
            <form action="${pageContext.request.contextPath}/admin" method="post">
                <input type="hidden" name="action" value="credit-savings-interest">
                <button type="submit" class="inline-flex items-center rounded-lg bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700 transition">
                    Credit Monthly Savings Interest
                </button>
            </form>
            <div class="text-xs text-gray-500">Credits interest one time per member per month and records INTEREST_CREDIT transactions.</div>
        </div>

        <c:if test="${param.msg == 'interestCredited'}">
            <div class="mb-6 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-700">
                Monthly savings interest credited successfully for <strong><c:out value="${empty param.count ? 0 : param.count}"/></strong> account(s).
            </div>
        </c:if>

        <c:if test="${param.error == 'interestCreditFailed'}">
            <div class="mb-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                Failed to credit savings interest. Please try again.
            </div>
        </c:if>

        <!-- Summary cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Total Loan Disbursed</div>
                <div class="text-3xl font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${loanRecovery['totalDisbursed'] != null ? loanRecovery['totalDisbursed'] : 0}" pattern="#,##0"/></div>
                <div class="text-xs text-gray-400 mt-1">${loanRecovery['totalLoans']} active loans</div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Loan Recovery Rate (Due Based)</div>
                <div class="text-3xl font-extrabold text-green-700">${loanRecovery['recoveryRate'] != null ? loanRecovery['recoveryRate'] : 0}%</div>
                <div class="text-xs text-gray-400 mt-1">Rs. <fmt:formatNumber value="${loanRecovery['totalCollected'] != null ? loanRecovery['totalCollected'] : 0}" pattern="#,##0"/> collected of Rs. <fmt:formatNumber value="${loanRecovery['totalDue'] != null ? loanRecovery['totalDue'] : 0}" pattern="#,##0"/> due</div>
                <div class="text-xs text-gray-400 mt-1">Remaining due: Rs. <fmt:formatNumber value="${loanRecovery['remainingDue'] != null ? loanRecovery['remainingDue'] : 0}" pattern="#,##0"/></div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Interest Earned</div>
                <div class="text-3xl font-extrabold text-blue-700">Rs. <fmt:formatNumber value="${interestEarned != null ? interestEarned : 0}" pattern="#,##0"/></div>
                <div class="text-xs text-gray-400 mt-1">Total savings interest credited</div>
            </div>
        </div>

        <!-- Monthly savings chart -->
        <div class="bg-white rounded-2xl border border-gray-100 p-6">
            <h2 class="text-sm font-bold text-gray-700 mb-4">Monthly Savings History — Last 6 Months</h2>
            <canvas id="savingsChart" height="100"></canvas>
        </div>

    </div></div>

<script>
    // Build chart data from JSTL
    const labels = [];
    const deposits = [];
    const withdrawals = [];
    const interests = [];
    const netFlow = [];
    <c:forEach var="row" items="${monthlySavings}">
    labels.push('${row["month"]}');
    deposits.push(${row["deposits"]});
    withdrawals.push(${row["withdrawals"]});
    interests.push(${row["interests"]});
    netFlow.push(${row["net"]});
    </c:forEach>

    new Chart(document.getElementById('savingsChart'), {
        type: 'bar',
        data: {
            labels,
            datasets: [
                {
                    label: 'Deposits (Rs.)',
                    data: deposits,
                    backgroundColor: 'rgba(22,163,74,0.20)',
                    borderColor: '#16a34a',
                    borderWidth: 1.5,
                    borderRadius: 8,
                },
                {
                    label: 'Withdrawals (Rs.)',
                    data: withdrawals,
                    backgroundColor: 'rgba(220,38,38,0.18)',
                    borderColor: '#dc2626',
                    borderWidth: 1.5,
                    borderRadius: 8,
                },
                {
                    label: 'Interest Credit (Rs.)',
                    data: interests,
                    backgroundColor: 'rgba(37,99,235,0.18)',
                    borderColor: '#2563eb',
                    borderWidth: 1.5,
                    borderRadius: 8,
                },
                {
                    type: 'line',
                    label: 'Net Flow (Rs.)',
                    data: netFlow,
                    borderColor: '#111827',
                    backgroundColor: 'rgba(17,24,39,0.08)',
                    borderWidth: 2,
                    pointRadius: 3,
                    pointHoverRadius: 4,
                    tension: 0.35,
                    fill: false,
                }
            ]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: true } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f3f4f6' },
                    ticks: { callback: v => 'Rs. ' + v.toLocaleString(), font: { size: 11 } } },
                x: { grid: { display: false }, ticks: { font: { size: 11 } } }
            }
        }
    });
</script>
</body></html>
