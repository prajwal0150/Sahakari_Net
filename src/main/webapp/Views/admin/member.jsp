<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- FILE: src/main/webapp/views/admin/members.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Members — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">
        <div class="flex items-center justify-between mb-6">
            <div><h1 class="text-2xl font-bold text-gray-900">Members</h1><p class="text-gray-500 text-sm mt-0.5">All cooperative members</p></div>
        </div>
        <!-- Search -->
        <form action="${pageContext.request.contextPath}/admin" method="get" class="mb-6 flex gap-3">
            <input type="hidden" name="page" value="members">
            <input type="text" name="q" value="${q}" placeholder="Search by name, phone or citizenship no..."
                   class="flex-1 border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
            <button type="submit" class="bg-green-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold hover:bg-green-800 transition">Search</button>
            <c:if test="${q != null}"><a href="${pageContext.request.contextPath}/admin?page=members" class="border border-gray-200 text-gray-600 px-4 py-2.5 rounded-xl text-sm hover:bg-gray-50 transition">Clear</a></c:if>
        </form>
        <!-- Table -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Member</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide hidden md:table-cell">Phone</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide hidden lg:table-cell">Citizenship No.</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Status</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Action</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:choose>
                    <c:when test="${empty members}">
                        <tr><td colspan="5" class="px-5 py-10 text-center text-gray-400 text-sm">No members found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="m" items="${members}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-5 py-3.5">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 rounded-full bg-green-100 flex items-center justify-center text-green-700 font-bold text-xs uppercase flex-shrink-0">
                                                ${m.fullName.substring(0,1)}
                                        </div>
                                        <div>
                                            <div class="font-semibold text-gray-900 text-xs">${m.fullName}</div>
                                            <div class="text-gray-400 text-xs">${m.username}</div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-5 py-3.5 text-gray-600 hidden md:table-cell text-xs">${m.phone}</td>
                                <td class="px-5 py-3.5 text-gray-600 hidden lg:table-cell text-xs font-mono">${m.citizenshipNo}</td>
                                <td class="px-5 py-3.5">
                                    <c:choose>
                                        <c:when test="${m.status == 'APPROVED'}"><span class="inline-flex items-center gap-1 bg-green-100 text-green-700 text-xs font-semibold px-2.5 py-1 rounded-full">Approved</span></c:when>
                                        <c:when test="${m.status == 'PENDING'}"><span class="inline-flex items-center gap-1 bg-amber-100 text-amber-700 text-xs font-semibold px-2.5 py-1 rounded-full">Pending</span></c:when>
                                        <c:otherwise><span class="inline-flex items-center gap-1 bg-red-100 text-red-700 text-xs font-semibold px-2.5 py-1 rounded-full">Rejected</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-5 py-3.5">
                                    <a href="${pageContext.request.contextPath}/admin?page=member-detail&id=${m.id}" class="text-xs text-green-700 font-semibold hover:underline">View →</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div></div>
</body></html>
