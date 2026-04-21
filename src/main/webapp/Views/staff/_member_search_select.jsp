<div class="bg-white rounded-2xl border border-gray-100 p-6 mb-6">
    <p class="text-sm font-semibold text-gray-700 mb-3">${memberSearchTitle}</p>
    <form action="${pageContext.request.contextPath}/staff" method="get" class="flex gap-3 flex-col sm:flex-row">
        <input type="hidden" name="page" value="${memberSearchPage}">
        <input type="text" name="q" value="${q}" placeholder="${memberSearchPlaceholder}" autofocus
               class="flex-1 border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 ${memberSearchInputRingClass} bg-gray-50">
        <button type="submit" class="${memberSearchButtonClass} text-white px-5 py-2.5 rounded-xl text-sm font-semibold transition">Find</button>
    </form>
</div>
