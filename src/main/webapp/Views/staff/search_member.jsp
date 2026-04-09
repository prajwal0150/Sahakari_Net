<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- FILE: src/main/webapp/views/staff/search-member.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Search Member — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Search Member</h1>
            <p class="text-gray-500 text-sm mt-0.5">Search by name, phone number, or citizenship number</p>
        </div>
        <form action="${pageContext.request.contextPath}/staff" method="get" class="flex gap-3 mb-6">
            <input type="hidden" name="page" value="search">
            <input type="text" name="q" value="${q}" autofocus placeholder="Search member..."
                   class="flex-1 border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
            <button type="submit" class="bg-green-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-green-800 transition">Search</button>
        </form>

        <c:if test="${q != null && !q.isEmpty()}">
            <c:choose>
                <c:when test="${empty members}">
                    <div class="bg-white rounded-2xl border border-gray-100 p-12 text-center">
                        <p class="text-gray-400 text-sm">No members found for "<strong>${q}</strong>"</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <c:forEach var="m" items="${members}">
                            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center justify-between">
                                <div class="flex items-center gap-4">
                                    <div class="w-11 h-11 rounded-xl bg-green-100 flex items-center justify-center text-green-700 font-bold text-lg uppercase">${m.fullName.substring(0,1)}</div>
                                    <div>
                                        <div class="font-bold text-gray-900 text-sm">${m.fullName}</div>
                                        <div class="text-xs text-gray-500 mt-0.5">${m.phone} &bull; <span class="font-mono">${m.citizenshipNo}</span></div>
                                    </div>
                                </div>
                                <div class="flex gap-2">
                                    <a href="${pageContext.request.contextPath}/staff?page=deposit&memberId=${m.id}"    class="text-xs font-semibold bg-green-100 text-green-700 px-3 py-1.5 rounded-lg hover:bg-green-200 transition">Deposit</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=withdrawal&memberId=${m.id}" class="text-xs font-semibold bg-red-100 text-red-600 px-3 py-1.5 rounded-lg hover:bg-red-200 transition">Withdraw</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=member-detail&id=${m.id}"   class="text-xs font-semibold bg-gray-100 text-gray-700 px-3 py-1.5 rounded-lg hover:bg-gray-200 transition">View →</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div></div>
</body></html>
