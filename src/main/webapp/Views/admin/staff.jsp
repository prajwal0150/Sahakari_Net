<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- FILE: src/main/webapp/views/admin/staff.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Staff Management - SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gradient-to-br from-gray-50 via-white to-emerald-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 py-8">

    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Staff Management</h1>
      <p class="text-gray-500 text-sm mt-0.5">Create staff accounts and manage active status.</p>
    </div>

    <c:if test="${param.msg == 'created'}">
      <div class="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 mb-5 text-sm">Staff account created successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'activated'}">
      <div class="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 mb-5 text-sm">Staff account activated successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'deactivated'}">
      <div class="bg-amber-50 border border-amber-200 text-amber-800 rounded-xl px-4 py-3 mb-5 text-sm">Staff account deactivated successfully.</div>
    </c:if>
    <c:if test="${param.msg == 'removed'}">
      <div class="bg-rose-50 border border-rose-200 text-rose-800 rounded-xl px-4 py-3 mb-5 text-sm">Staff account removed successfully.</div>
    </c:if>

    <c:if test="${not empty param.error}">
      <div class="bg-red-50 border border-red-200 text-red-800 rounded-xl px-4 py-3 mb-5 text-sm">
        <c:choose>
          <c:when test="${param.error == 'missingFields'}">All fields are required.</c:when>
          <c:when test="${param.error == 'invalidEmail'}">Please enter a valid email address.</c:when>
          <c:when test="${param.error == 'invalidPhone'}">Phone must be in 97xxxxxxxx or 98xxxxxxxx format.</c:when>
          <c:when test="${param.error == 'usernameExists'}">Username already exists.</c:when>
          <c:when test="${param.error == 'emailExists'}">Email already exists.</c:when>
          <c:when test="${param.error == 'invalidStaff'}">Invalid staff account selected.</c:when>
          <c:when test="${param.error == 'invalidPassword'}">Password must be at least 6 characters.</c:when>
          <c:when test="${param.error == 'removeFailed'}">Could not remove the staff account. Please try again.</c:when>
          <c:otherwise>Operation failed. Please try again.</c:otherwise>
        </c:choose>
      </div>
    </c:if>

    <div class="grid grid-cols-1 xl:grid-cols-[420px_minmax(0,1fr)] gap-6 items-start">
      <div>
        <div class="bg-white rounded-2xl border border-gray-100 p-5 shadow-sm">
          <h2 class="text-sm font-bold text-gray-700 mb-4">Create Staff Account</h2>
          <p class="text-xs text-gray-500 mb-4">Username is set as staff email. Staff can login with that email and the password you set below.</p>
          <form action="${pageContext.request.contextPath}/admin" method="post" class="space-y-3" autocomplete="off">
            <input type="hidden" name="action" value="create-staff">

            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Full Name</label>
              <input type="text" name="fullName" required
                   class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Gender</label>
              <select name="gender" required
                   class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                <option value="">Select gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Email</label>
                  <input type="email" name="email" required autocomplete="off"
                   class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Password</label>
                  <input type="password" name="password" required minlength="6" autocomplete="new-password"
                    class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Phone Number</label>
              <input type="text" name="phone" required maxlength="10"
                   class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Permanent Address</label>
              <input type="text" name="permanentAddress" required
                   class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
            </div>
            <div>
              <label class="block text-xs font-semibold text-gray-600 mb-1">Temporary Address</label>
              <input type="text" name="temporaryAddress" required
                   class="w-full border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
            </div>
            <button type="submit" class="w-full bg-green-700 text-white text-sm font-semibold rounded-xl py-2.5 hover:bg-green-800 transition">Create Staff</button>
          </form>
        </div>
      </div>

      <div class="min-w-0">
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden shadow-sm">
          <div class="px-5 py-4 border-b border-gray-100">
            <h2 class="text-sm font-bold text-gray-700">Existing Staff</h2>
          </div>

          <c:choose>
            <c:when test="${empty staffList}">
              <div class="p-8 text-sm text-gray-500 text-center">No staff users found.</div>
            </c:when>
            <c:otherwise>
              <div class="overflow-x-auto">
                <table class="w-full min-w-[900px] text-sm">
                  <thead class="bg-gray-50 border-b border-gray-100">
                  <tr>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Name</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Gender</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Username</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Email</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Phone</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Status</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase tracking-wide">Action</th>
                  </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-50">
                  <c:forEach var="s" items="${staffList}">
                    <tr class="hover:bg-gray-50">
                      <td class="px-5 py-3 text-gray-700">${empty s.fullName ? '-' : s.fullName}</td>
                      <td class="px-5 py-3 text-gray-600">${empty s.gender ? '-' : s.gender}</td>
                      <td class="px-5 py-3 text-gray-800 font-medium">${s.username}</td>
                      <td class="px-5 py-3 text-gray-600">${empty s.email ? '-' : s.email}</td>
                      <td class="px-5 py-3 text-gray-600">${empty s.phone ? '-' : s.phone}</td>
                      <td class="px-5 py-3">
                        <c:choose>
                          <c:when test="${s.active}">
                            <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2.5 py-1 rounded-full">Active</span>
                          </c:when>
                          <c:otherwise>
                            <span class="inline-block bg-gray-100 text-gray-600 text-xs font-semibold px-2.5 py-1 rounded-full">Inactive</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="px-5 py-3">
                        <div class="flex flex-wrap gap-2">
                          <form action="${pageContext.request.contextPath}/admin" method="post" class="inline">
                            <input type="hidden" name="action" value="toggle-staff-active">
                            <input type="hidden" name="userId" value="${s.userId}">
                            <button type="submit"
                                class="text-xs font-semibold px-3 py-1.5 rounded-lg border transition ${s.active ? 'bg-red-50 text-red-700 border-red-200 hover:bg-red-100' : 'bg-green-50 text-green-700 border-green-200 hover:bg-green-100'}">
                              <c:choose>
                                <c:when test="${s.active}">Deactivate</c:when>
                                <c:otherwise>Activate</c:otherwise>
                              </c:choose>
                            </button>
                          </form>
                          <form action="${pageContext.request.contextPath}/admin" method="post" class="inline" onsubmit="return confirm('Remove this staff account permanently?');">
                            <input type="hidden" name="action" value="remove-staff">
                            <input type="hidden" name="userId" value="${s.userId}">
                            <button type="submit" class="text-xs font-semibold px-3 py-1.5 rounded-lg border bg-rose-50 text-rose-700 border-rose-200 hover:bg-rose-100 transition">Remove</button>
                          </form>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>
</div>
</body></html>
