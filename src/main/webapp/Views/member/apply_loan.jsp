<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: src/main/webapp/views/member/apply-loan.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Apply for Loan — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-2xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Apply for a Loan</h1>
        <p class="text-gray-500 text-sm mb-6">Fill in the details below. Your request will be reviewed by the Admin.</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 mb-4 text-sm"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="bg-white rounded-2xl border border-gray-100 p-7">
            <form action="${pageContext.request.contextPath}/loan" method="post" id="loanForm">
                <input type="hidden" name="action" value="apply">
                <div class="space-y-5">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1.5">Loan Amount (Rs.) <span class="text-red-500">*</span></label>
                        <input type="number" name="amount" id="amount" min="1000" step="100" required placeholder="e.g. 50000"
                               oninput="calcEMI()"
                               class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50 text-lg font-bold">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1.5">Duration (Months) <span class="text-red-500">*</span></label>
                        <select name="durationMonths" id="duration" required onchange="calcEMI()"
                                class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                            <option value="6">6 months</option>
                            <option value="12" selected>12 months (1 year)</option>
                            <option value="24">24 months (2 years)</option>
                            <option value="36">36 months (3 years)</option>
                            <option value="60">60 months (5 years)</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1.5">Purpose of Loan <span class="text-red-500">*</span></label>
                        <textarea name="purpose" required rows="3" placeholder="Describe why you need this loan..."
                                  class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50 resize-none"></textarea>
                    </div>

                    <!-- EMI calculator -->
                    <div id="emiBox" class="bg-green-50 border border-green-200 rounded-xl p-4 hidden">
                        <div class="text-xs font-semibold text-green-700 uppercase tracking-wide mb-2">Estimated Monthly EMI</div>
                        <div class="text-3xl font-extrabold text-green-800">Rs. <span id="emiValue">0</span></div>
                        <div class="text-xs text-green-600 mt-1">at 12% annual interest</div>
                    </div>

                    <button type="submit" class="w-full bg-green-700 hover:bg-green-800 text-white font-bold py-3.5 rounded-xl text-sm transition">
                        Submit Loan Application →
                    </button>
                    <p class="text-xs text-center text-gray-400">Your loan will be processed after Admin approval. EMI starts from the disbursement date.</p>
                </div>
            </form>
        </div>
    </div></div>

<script>
    function calcEMI() {
        const P = parseFloat(document.getElementById('amount').value) || 0;
        const n = parseInt(document.getElementById('duration').value) || 12;
        const r = 12 / 100 / 12; // 12% annual monthly rate
        const box = document.getElementById('emiBox');
        const val = document.getElementById('emiValue');
        if (P <= 0) { box.classList.add('hidden'); return; }
        const emi = P * r * Math.pow(1+r,n) / (Math.pow(1+r,n) - 1);
        val.textContent = emi.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        box.classList.remove('hidden');
    }
</script>
</body></html>
