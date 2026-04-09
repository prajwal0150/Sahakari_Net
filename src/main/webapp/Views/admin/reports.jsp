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

        <!-- Summary cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Total Loan Disbursed</div>
                <div class="text-3xl font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${loanRecovery['totalDisbursed'] != null ? loanRecovery['totalDisbursed'] : 0}" pattern="#,##0"/></div>
                <div class="text-xs text-gray-400 mt-1">${loanRecovery['totalLoans']} active loans</div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Loan Recovery Rate</div>
                <div class="text-3xl font-extrabold text-green-700">${loanRecovery['recoveryRate'] != null ? loanRecovery['recoveryRate'] : 0}%</div>
                <div class="text-xs text-gray-400 mt-1">Rs. <fmt:formatNumber value="${loanRecovery['totalCollected'] != null ? loanRecovery['totalCollected'] : 0}" pattern="#,##0"/> collected</div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Interest Earned</div>
                <div class="text-3xl font-extrabold text-blue-700">Rs. <fmt:formatNumber value="${interestEarned != null ? interestEarned : 0}" pattern="#,##0"/></div>
                <div class="text-xs text-gray-400 mt-1">Total savings interest credited</div>
            </div>
        </div>

        <!-- Monthly savings chart -->
        <div class="bg-white rounded-2xl border border-gray-100 p-6">
            <h2 class="text-sm font-bold text-gray-700 mb-4">Monthly Deposits — Last 6 Months</h2>
            <canvas id="savingsChart" height="100"></canvas>
        </div>

    </div></div>

<script>
    // Build chart data from JSTL
    const labels = [];
    const data   = [];
    <c:forEach var="row" items="${monthlySavings}">
    labels.push('${row["month"]}');
    data.push(${row["total"]});
    </c:forEach>

    new Chart(document.getElementById('savingsChart'), {
        type: 'bar',
        data: {
            labels,
            datasets: [{
                label: 'Total Deposits (Rs.)',
                data,
                backgroundColor: 'rgba(21,128,61,0.15)',
                borderColor: '#15803d',
                borderWidth: 2,
                borderRadius: 8,
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f3f4f6' },
                    ticks: { callback: v => 'Rs. ' + v.toLocaleString(), font: { size: 11 } } },
                x: { grid: { display: false }, ticks: { font: { size: 11 } } }
            }
        }
    });
</script>
</body></html>
