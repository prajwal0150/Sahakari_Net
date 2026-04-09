<%@ page contentType="text/html;charset=UTF-8" %>
<%-- FILE: src/main/webapp/index.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SahakariNet — Digital Cooperative Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        .hero-bg { background: linear-gradient(135deg, #064e3b 0%, #065f46 50%, #047857 100%); }
        .card-hover { transition: transform 0.2s, box-shadow 0.2s; }
        .card-hover:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
        .stat-card { background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.2); }
    </style>
</head>
<body class="bg-gray-50">

<!-- NAVBAR -->
<nav class="bg-white border-b border-gray-100 sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <div class="flex items-center gap-3">
            <div class="w-9 h-9 bg-green-700 rounded-xl flex items-center justify-center"><span class="text-white font-bold">S</span></div>
            <span class="text-xl font-bold text-gray-900">Sahakar<span class="text-green-700">iNet</span></span>
        </div>
        <div class="hidden md:flex items-center gap-6">
            <a href="about.jsp"   class="text-sm text-gray-600 hover:text-green-700 font-medium transition">About</a>
            <a href="contact.jsp" class="text-sm text-gray-600 hover:text-green-700 font-medium transition">Contact</a>
            <a href="login.jsp"   class="text-sm font-semibold text-green-700 border border-green-700 px-4 py-2 rounded-lg hover:bg-green-50 transition">Login</a>
            <a href="register.jsp" class="text-sm font-semibold text-white bg-green-700 px-4 py-2 rounded-lg hover:bg-green-800 transition">Register</a>
        </div>
    </div>
</nav>

<!-- HERO -->
<section class="hero-bg text-white">
    <div class="max-w-7xl mx-auto px-6 py-24 lg:py-32">
        <div class="max-w-3xl">
      <span class="inline-flex items-center gap-2 bg-white bg-opacity-20 text-white text-xs font-semibold px-3 py-1.5 rounded-full mb-6">
        <span class="w-2 h-2 bg-green-400 rounded-full animate-pulse"></span>
        Nepal's Cooperative Management Platform
      </span>
            <h1 class="text-5xl lg:text-6xl font-extrabold leading-tight mb-6">
                Digitalise your<br>cooperative today
            </h1>
            <p class="text-lg text-green-100 mb-10 max-w-xl">
                SahakariNet replaces paper ledgers with a secure, role-based platform for Nepal's 34,000+ cooperatives. Manage members, savings, loans, and reports — all in one place.
            </p>
            <div class="flex flex-wrap gap-4">
                <a href="register.jsp" class="bg-white text-green-800 font-bold px-8 py-3.5 rounded-xl hover:bg-green-50 transition text-sm">
                    Join as a Member →
                </a>
                <a href="login.jsp" class="border border-white text-white font-semibold px-8 py-3.5 rounded-xl hover:bg-white hover:bg-opacity-10 transition text-sm">
                    Staff / Admin Login
                </a>
            </div>
        </div>
        <!-- Stats -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-16">
            <div class="stat-card rounded-2xl p-5 text-center">
                <div class="text-3xl font-extrabold text-white">34K+</div>
                <div class="text-xs text-green-200 mt-1">Cooperatives in Nepal</div>
            </div>
            <div class="stat-card rounded-2xl p-5 text-center">
                <div class="text-3xl font-extrabold text-white">3</div>
                <div class="text-xs text-green-200 mt-1">User roles supported</div>
            </div>
            <div class="stat-card rounded-2xl p-5 text-center">
                <div class="text-3xl font-extrabold text-white">100%</div>
                <div class="text-xs text-green-200 mt-1">Digital & paperless</div>
            </div>
            <div class="stat-card rounded-2xl p-5 text-center">
                <div class="text-3xl font-extrabold text-white">Free</div>
                <div class="text-xs text-green-200 mt-1">Open source project</div>
            </div>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="max-w-7xl mx-auto px-6 py-20">
    <div class="text-center mb-14">
        <h2 class="text-3xl font-bold text-gray-900 mb-3">Everything your cooperative needs</h2>
        <p class="text-gray-500 text-sm max-w-xl mx-auto">One secure platform for all your daily operations — from member onboarding to financial reporting.</p>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Feature cards -->
        <div class="bg-white rounded-2xl border border-gray-100 p-7 card-hover">
            <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center mb-5">
                <svg class="w-6 h-6 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
            </div>
            <h3 class="font-bold text-gray-900 mb-2">Member Management</h3>
            <p class="text-sm text-gray-500 leading-relaxed">Digital registration with admin approval workflow. Search by name, phone, or citizenship number instantly.</p>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 p-7 card-hover">
            <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mb-5">
                <svg class="w-6 h-6 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
            </div>
            <h3 class="font-bold text-gray-900 mb-2">Savings & Deposits</h3>
            <p class="text-sm text-gray-500 leading-relaxed">Real-time balance tracking, auto interest calculation, and complete transaction history for every member.</p>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 p-7 card-hover">
            <div class="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center mb-5">
                <svg class="w-6 h-6 text-amber-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
            </div>
            <h3 class="font-bold text-gray-900 mb-2">Loan Management</h3>
            <p class="text-sm text-gray-500 leading-relaxed">Apply, approve, disburse, and track loan repayments with auto-generated EMI schedules and defaulter alerts.</p>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 p-7 card-hover">
            <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center mb-5">
                <svg class="w-6 h-6 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
            </div>
            <h3 class="font-bold text-gray-900 mb-2">Financial Reports</h3>
            <p class="text-sm text-gray-500 leading-relaxed">Monthly savings summaries, loan recovery rates, interest earned — all generated instantly for auditing.</p>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 p-7 card-hover">
            <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center mb-5">
                <svg class="w-6 h-6 text-red-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/></svg>
            </div>
            <h3 class="font-bold text-gray-900 mb-2">Role-Based Security</h3>
            <p class="text-sm text-gray-500 leading-relaxed">Admin, Staff, and Member roles with encrypted passwords and session-based authentication throughout.</p>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 p-7 card-hover">
            <div class="w-12 h-12 bg-teal-100 rounded-xl flex items-center justify-center mb-5">
                <svg class="w-6 h-6 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 18h.01M8 21h8a2 2 0 002-2v-2H6v2a2 2 0 002 2zm10-10.5V6a2 2 0 00-2-2H6a2 2 0 00-2 2v4.5"/></svg>
            </div>
            <h3 class="font-bold text-gray-900 mb-2">Fully Responsive</h3>
            <p class="text-sm text-gray-500 leading-relaxed">Works on any device — desktop, tablet, or mobile. Accessible from anywhere with an internet connection.</p>
        </div>
    </div>
</section>

<!-- 3 ROLES SECTION -->
<section class="bg-gray-900 py-20">
    <div class="max-w-7xl mx-auto px-6">
        <div class="text-center mb-14">
            <h2 class="text-3xl font-bold text-white mb-3">Three roles, one system</h2>
            <p class="text-gray-400 text-sm">Each role has a tailored dashboard with exactly the permissions they need.</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-gray-800 rounded-2xl p-7 border border-gray-700">
                <div class="w-10 h-10 bg-red-500 bg-opacity-20 rounded-xl flex items-center justify-center mb-4">
                    <span class="text-red-400 font-bold">A</span>
                </div>
                <h3 class="text-white font-bold mb-1">Admin</h3>
                <p class="text-gray-400 text-xs mb-4">Full system control</p>
                <ul class="space-y-2 text-sm text-gray-300">
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Approve member registrations</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Approve & reject loans</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>View financial reports</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Manage staff accounts</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>View loan defaulters</li>
                </ul>
            </div>
            <div class="bg-gray-800 rounded-2xl p-7 border border-green-500">
                <div class="w-10 h-10 bg-amber-500 bg-opacity-20 rounded-xl flex items-center justify-center mb-4">
                    <span class="text-amber-400 font-bold">S</span>
                </div>
                <h3 class="text-white font-bold mb-1">Staff</h3>
                <p class="text-gray-400 text-xs mb-4">Day-to-day operations</p>
                <ul class="space-y-2 text-sm text-gray-300">
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Record deposits & withdrawals</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Disburse approved loans</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Record loan repayments</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Search member records</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Auto interest calculation</li>
                </ul>
            </div>
            <div class="bg-gray-800 rounded-2xl p-7 border border-gray-700">
                <div class="w-10 h-10 bg-green-500 bg-opacity-20 rounded-xl flex items-center justify-center mb-4">
                    <span class="text-green-400 font-bold">M</span>
                </div>
                <h3 class="text-white font-bold mb-1">Member</h3>
                <p class="text-gray-400 text-xs mb-4">Self-service account</p>
                <ul class="space-y-2 text-sm text-gray-300">
                    <li class="flex gap-2"><span class="text-green-400">✓</span>View savings balance</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Apply for a loan</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>View transaction history</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>Track repayment schedule</li>
                    <li class="flex gap-2"><span class="text-green-400">✓</span>View loan status</li>
                </ul>
            </div>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="max-w-7xl mx-auto px-6 py-20 text-center">
    <h2 class="text-3xl font-bold text-gray-900 mb-4">Ready to digitise your cooperative?</h2>
    <p class="text-gray-500 mb-8 text-sm">Register as a member or contact your cooperative admin to get started.</p>
    <div class="flex justify-center gap-4">
        <a href="register.jsp" class="bg-green-700 text-white font-semibold px-8 py-3 rounded-xl hover:bg-green-800 transition text-sm">Register as Member</a>
        <a href="contact.jsp"  class="border border-gray-300 text-gray-700 font-semibold px-8 py-3 rounded-xl hover:bg-gray-50 transition text-sm">Contact Us</a>
    </div>
</section>

<!-- FOOTER -->
<footer class="bg-white border-t border-gray-100 py-8 text-center text-xs text-gray-400">
    <p class="font-semibold text-gray-500 mb-1">SahakariNet</p>
    <p>CS5054NT Advanced Programming &amp; Technologies &mdash; London Metropolitan University</p>
    <p class="mt-1">Built with Java · JSP · Servlets · MySQL · Tailwind CSS</p>
</footer>

</body>
</html>
