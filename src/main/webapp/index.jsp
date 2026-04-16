<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SahakariNet - Digital Cooperative Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #f8fafc;
            --text: #0f172a;
            --muted: #64748b;
            --line: rgba(148, 163, 184, 0.2);
            --blue: #2563eb;
            --blue-strong: #1d4ed8;
            --blue-soft: #dbeafe;
            --panel: #ffffff;
        }

        html { scroll-behavior: smooth; }
        body {
            font-family: 'Inter', sans-serif;
            background:
                radial-gradient(circle at top left, rgba(37, 99, 235, 0.08), transparent 28%),
                linear-gradient(180deg, #ffffff 0%, #f8fbff 36%, #eef4ff 36%, #eef4ff 66%, #ffffff 66%, #ffffff 100%);
            color: var(--text);
        }

        .container-wide { max-width: 1180px; }

        .glass-border {
            border: 1px solid rgba(37, 99, 235, 0.12);
            box-shadow: 0 18px 50px rgba(15, 23, 42, 0.08);
        }

        .soft-panel {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(18px);
            border: 1px solid rgba(255, 255, 255, 0.65);
        }

        .hero-shadow {
            box-shadow: 0 28px 60px rgba(15, 23, 42, 0.14);
        }

        .card-hover {
            transition: transform 180ms ease, box-shadow 180ms ease, border-color 180ms ease;
        }

        .card-hover:hover {
            transform: translateY(-4px);
            box-shadow: 0 24px 45px rgba(15, 23, 42, 0.08);
            border-color: rgba(37, 99, 235, 0.18);
        }

        .section-title {
            letter-spacing: -0.04em;
        }
    </style>
</head>
<body class="min-h-screen text-slate-900">
<header class="sticky top-0 z-50 bg-white/90 backdrop-blur-xl border-b border-slate-200/70">
    <div class="container-wide mx-auto px-5 lg:px-8 h-16 flex items-center justify-between">
        <a href="index.jsp" class="flex items-center gap-2.5 font-extrabold text-slate-900">
            <span class="w-7 h-7 rounded-lg bg-blue-600 text-white flex items-center justify-center shadow-sm">
                <svg viewBox="0 0 24 24" fill="none" class="w-4 h-4" stroke="currentColor" stroke-width="2" aria-hidden="true">
                    <path d="M4 12.5 12 5l8 7.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M6.5 10.5V19h11V10.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </span>
            <span class="tracking-tight">Sahakari<span class="text-blue-600">Net</span></span>
        </a>

        <nav class="hidden md:flex items-center gap-8 text-sm text-slate-500">
            <a href="#features" class="hover:text-slate-900 transition">Features</a>
            <a href="#dashboards" class="hover:text-slate-900 transition">Dashboards</a>
            <a href="about.jsp" class="hover:text-slate-900 transition">About</a>
            <a href="contact.jsp" class="hover:text-slate-900 transition">Contact</a>
        </nav>

        <div class="flex items-center gap-3 text-sm">
            <a href="login.jsp" class="px-3.5 py-2 text-slate-700 hover:text-slate-900 transition">Log in</a>
            <a href="register.jsp" class="px-4 py-2.5 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-700 transition shadow-sm shadow-blue-200">
                Register
            </a>
        </div>
    </div>
</header>

<main>
    <section class="px-5 lg:px-8 pt-16 pb-20 lg:pt-24 lg:pb-28">
        <div class="container-wide mx-auto grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
            <div class="max-w-xl">
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-blue-50 border border-blue-100 text-blue-700 text-xs font-semibold mb-6">
                    <span class="w-2 h-2 rounded-full bg-blue-500"></span>
                    Empowering Nepal's Cooperatives
                </div>

                <h1 class="section-title text-4xl sm:text-5xl lg:text-6xl font-black leading-[1.02] tracking-tight text-slate-950">
                    Digitize Your
                    Cooperative
                    Management
                </h1>

                <p class="mt-6 text-base sm:text-lg leading-8 text-slate-500 max-w-lg">
                    Move beyond manual ledgers. SahakariNet brings efficiency, transparency, and security to your daily financial operations with a complete web-based system.
                </p>

                <div class="flex flex-wrap gap-3 mt-8">
                    <a href="register.jsp" class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-lg bg-blue-600 text-white font-semibold shadow-sm shadow-blue-200 hover:bg-blue-700 transition">
                        Get Started Today
                        <svg viewBox="0 0 20 20" fill="currentColor" class="w-4 h-4" aria-hidden="true"><path fill-rule="evenodd" d="M7.47 4.47a.75.75 0 011.06 0l5 5a.75.75 0 010 1.06l-5 5a.75.75 0 11-1.06-1.06L11.94 10 7.47 5.53a.75.75 0 010-1.06z" clip-rule="evenodd"/></svg>
                    </a>
                    <a href="#features" class="inline-flex items-center justify-center px-5 py-3 rounded-lg bg-white border border-slate-200 text-slate-700 font-medium hover:border-slate-300 hover:bg-slate-50 transition">
                        Learn More
                    </a>
                </div>
            </div>

            <div class="relative">
                <div class="absolute -inset-3 rounded-[28px] bg-gradient-to-br from-blue-200/30 via-transparent to-blue-500/30 blur-2xl"></div>
                <div class="relative soft-panel glass-border rounded-[22px] p-4 sm:p-5 lg:p-6 hero-shadow">
                    <div class="relative overflow-hidden rounded-[18px] bg-gradient-to-br from-blue-50 via-white to-blue-300/80 p-4 sm:p-5 lg:p-6 min-h-[320px] flex items-center justify-center">
                        <div class="absolute inset-x-0 top-0 h-10 bg-gradient-to-r from-blue-700 via-blue-600 to-blue-500 rounded-t-[18px]"></div>

                        <div class="relative w-full max-w-[470px] rounded-[14px] bg-slate-950/90 p-3 shadow-2xl shadow-slate-900/20">
                            <div class="rounded-[10px] bg-slate-100 overflow-hidden">
                                <div class="h-5 bg-blue-600/95 flex items-center gap-1.5 px-2.5">
                                    <span class="w-1.5 h-1.5 rounded-full bg-white/90"></span>
                                    <span class="w-1.5 h-1.5 rounded-full bg-white/70"></span>
                                    <span class="w-1.5 h-1.5 rounded-full bg-white/50"></span>
                                </div>
                                <div class="p-3 sm:p-4 bg-slate-50">
                                    <div class="grid grid-cols-[120px_1fr] gap-3 items-start">
                                        <aside class="rounded-xl bg-blue-100/70 p-3">
                                            <div class="space-y-2">
                                                <div class="h-2.5 w-16 rounded-full bg-blue-200"></div>
                                                <div class="h-2.5 w-20 rounded-full bg-blue-200"></div>
                                                <div class="h-2.5 w-12 rounded-full bg-blue-300"></div>
                                                <div class="mt-3 h-16 rounded-xl bg-white border border-blue-100"></div>
                                                <div class="h-12 rounded-xl bg-white border border-blue-100"></div>
                                            </div>
                                        </aside>

                                        <section class="space-y-3">
                                            <div class="flex items-center justify-between">
                                                <div>
                                                    <div class="h-3 w-20 rounded-full bg-slate-200 mb-2"></div>
                                                    <div class="h-5 w-28 rounded-full bg-slate-300"></div>
                                                </div>
                                                <div class="h-8 w-8 rounded-full bg-blue-200"></div>
                                            </div>

                                            <div class="grid grid-cols-3 gap-3">
                                                <div class="rounded-xl bg-white border border-slate-100 p-3 shadow-sm">
                                                    <div class="h-2.5 w-14 rounded-full bg-slate-200 mb-3"></div>
                                                    <div class="h-5 w-16 rounded-full bg-blue-200"></div>
                                                </div>
                                                <div class="rounded-xl bg-white border border-slate-100 p-3 shadow-sm">
                                                    <div class="h-2.5 w-12 rounded-full bg-slate-200 mb-3"></div>
                                                    <div class="h-5 w-20 rounded-full bg-blue-200"></div>
                                                </div>
                                                <div class="rounded-xl bg-white border border-slate-100 p-3 shadow-sm">
                                                    <div class="h-2.5 w-10 rounded-full bg-slate-200 mb-3"></div>
                                                    <div class="h-5 w-14 rounded-full bg-blue-200"></div>
                                                </div>
                                            </div>

                                            <div class="grid grid-cols-2 gap-3">
                                                <div class="rounded-2xl bg-white border border-slate-100 p-3 h-40 shadow-sm">
                                                    <div class="h-3 w-24 rounded-full bg-slate-200 mb-4"></div>
                                                    <div class="flex items-end gap-2 h-24 pt-10">
                                                        <span class="w-3 bg-blue-200 rounded-t-md h-10"></span>
                                                        <span class="w-3 bg-blue-300 rounded-t-md h-16"></span>
                                                        <span class="w-3 bg-blue-400 rounded-t-md h-12"></span>
                                                        <span class="w-3 bg-blue-500 rounded-t-md h-20"></span>
                                                        <span class="w-3 bg-blue-300 rounded-t-md h-14"></span>
                                                        <span class="w-3 bg-blue-400 rounded-t-md h-24"></span>
                                                    </div>
                                                </div>
                                                <div class="rounded-2xl bg-white border border-slate-100 p-3 h-40 shadow-sm flex flex-col">
                                                    <div class="h-3 w-24 rounded-full bg-slate-200 mb-4"></div>
                                                    <div class="flex-1 flex items-center justify-center">
                                                        <div class="w-28 h-28 rounded-full border-[14px] border-blue-500/20 border-r-blue-600 border-b-blue-600"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </section>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="features" class="px-5 lg:px-8 py-20 bg-[#eaf2ff]">
        <div class="container-wide mx-auto">
            <div class="max-w-3xl mx-auto text-center mb-14">
                <h2 class="section-title text-3xl sm:text-4xl font-extrabold text-slate-900">Built for Modern Cooperatives</h2>
                <p class="mt-4 text-slate-500 leading-7">
                    Everything you need to run your cooperative efficiently, securely, and transparently in one unified MVC architecture platform.
                </p>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5 lg:gap-6">
                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-6">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 mb-5"></div>
                    <h3 class="font-semibold text-lg text-slate-900">Secure & Transparent</h3>
                    <p class="mt-3 text-sm leading-6 text-slate-500">Encrypted passwords, secure user sessions, and a comprehensive audit trail build trust among your members and reduce fraud risks.</p>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-6">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 mb-5"></div>
                    <h3 class="font-semibold text-lg text-slate-900">Automated Calculations</h3>
                    <p class="mt-3 text-sm leading-6 text-slate-500">The system automatically calculates complex interest rates on savings and loans, eliminating manual errors and saving valuable staff time.</p>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-6">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 mb-5"></div>
                    <h3 class="font-semibold text-lg text-slate-900">Digital Loan Processing</h3>
                    <p class="mt-3 text-sm leading-6 text-slate-500">Manage the entire loan lifecycle from member application submission to admin approval, fund disbursement, and repayment tracking.</p>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-6">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 mb-5"></div>
                    <h3 class="font-semibold text-lg text-slate-900">Real-Time Reporting</h3>
                    <p class="mt-3 text-sm leading-6 text-slate-500">Generate accurate reports for auditing instantly. View monthly savings totals, loan recovery rates, and track defaulters easily.</p>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-6">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 mb-5"></div>
                    <h3 class="font-semibold text-lg text-slate-900">Member Management</h3>
                    <p class="mt-3 text-sm leading-6 text-slate-500">Streamline registrations with automated approval workflows. Maintain complete digital profiles including citizenship details and history.</p>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-6">
                    <div class="w-10 h-10 rounded-xl bg-blue-50 mb-5"></div>
                    <h3 class="font-semibold text-lg text-slate-900">Complete History</h3>
                    <p class="mt-3 text-sm leading-6 text-slate-500">Access full transaction histories across the cooperative or search specific member records by name, phone, or citizenship number.</p>
                </article>
            </div>
        </div>
    </section>

    <section id="dashboards" class="px-5 lg:px-8 py-24 bg-white">
        <div class="container-wide mx-auto">
            <div class="max-w-3xl mx-auto text-center mb-14">
                <h2 class="section-title text-3xl sm:text-4xl font-extrabold text-slate-900">Tailored Dashboards for Every Role</h2>
                <p class="mt-4 text-slate-500 leading-7">
                    SahakariNet implements strict role-based access control, providing specific tools and views based on administrative responsibilities.
                </p>
            </div>

            <div class="grid lg:grid-cols-3 gap-5 lg:gap-6">
                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-7">
                    <div class="flex items-center gap-3 mb-6">
                        <div class="w-12 h-12 rounded-xl bg-blue-50"></div>
                        <h3 class="text-xl font-semibold text-slate-900">Admin View</h3>
                    </div>
                    <ul class="space-y-3 text-sm leading-6 text-slate-500">
                        <li>Approve or reject member registrations</li>
                        <li>Review and approve loan applications</li>
                        <li>View loan defaulter lists instantly</li>
                        <li>Generate comprehensive financial reports</li>
                        <li>Manage staff accounts and permissions</li>
                    </ul>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-7">
                    <div class="flex items-center gap-3 mb-6">
                        <div class="w-12 h-12 rounded-xl bg-emerald-50"></div>
                        <h3 class="text-xl font-semibold text-slate-900">Staff View</h3>
                    </div>
                    <ul class="space-y-3 text-sm leading-6 text-slate-500">
                        <li>Record member deposits and withdrawals</li>
                        <li>Process approved loan disbursements</li>
                        <li>Record loan repayments from members</li>
                        <li>Search member records efficiently</li>
                        <li>View automated interest calculations</li>
                    </ul>
                </article>

                <article class="card-hover bg-white rounded-2xl border border-slate-200 p-7">
                    <div class="flex items-center gap-3 mb-6">
                        <div class="w-12 h-12 rounded-xl bg-violet-50"></div>
                        <h3 class="text-xl font-semibold text-slate-900">Member View</h3>
                    </div>
                    <ul class="space-y-3 text-sm leading-6 text-slate-500">
                        <li>View personal savings balance and shares</li>
                        <li>Submit loan applications directly online</li>
                        <li>View detailed loan repayment schedules</li>
                        <li>Track personal transaction history</li>
                        <li>Update personal profile details securely</li>
                    </ul>
                </article>
            </div>
        </div>
    </section>

    <section class="px-5 lg:px-8 py-20 bg-blue-600 text-white">
        <div class="container-wide mx-auto text-center max-w-3xl">
            <h2 class="section-title text-3xl sm:text-4xl font-extrabold tracking-tight">Ready to Transform Your Cooperative?</h2>
            <p class="mt-5 text-blue-100 leading-7">
                Join the movement towards digital empowerment in Nepal's cooperative sector. Reduce manual errors, build trust, and save time with SahakariNet.
            </p>
            <div class="flex flex-wrap justify-center gap-3 mt-8">
                <a href="register.jsp" class="px-5 py-3 rounded-lg bg-white text-blue-700 font-semibold hover:bg-blue-50 transition">
                    Register Now
                </a>
                <a href="contact.jsp" class="px-5 py-3 rounded-lg border border-white/30 bg-white/5 text-white font-medium hover:bg-white/10 transition">
                    Contact Sales
                </a>
            </div>
        </div>
    </section>
</main>

<footer class="bg-slate-950 text-slate-300">
    <div class="container-wide mx-auto px-5 lg:px-8 py-14 lg:py-16 grid sm:grid-cols-2 lg:grid-cols-4 gap-10">
        <div>
            <div class="flex items-center gap-2.5 font-extrabold text-white">
                <span class="w-8 h-8 rounded-lg bg-white text-slate-950 flex items-center justify-center">
                    <svg viewBox="0 0 24 24" fill="none" class="w-4 h-4" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <path d="M4 12.5 12 5l8 7.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <path d="M6.5 10.5V19h11V10.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                </span>
                <span>SahakariNet</span>
            </div>
            <p class="mt-4 text-sm leading-7 text-slate-400 max-w-xs">
                Empowering Nepal's cooperative sector with secure, digital, and efficient web-based management tools.
            </p>
        </div>

        <div>
            <h3 class="text-white font-semibold mb-4">Platform</h3>
            <ul class="space-y-3 text-sm text-slate-400">
                <li><a href="#features" class="hover:text-white transition">Features</a></li>
                <li><a href="#dashboards" class="hover:text-white transition">Role Access</a></li>
                <li><a href="#" class="hover:text-white transition">Security & Privacy</a></li>
                <li><a href="#" class="hover:text-white transition">System Requirements</a></li>
            </ul>
        </div>

        <div>
            <h3 class="text-white font-semibold mb-4">Company</h3>
            <ul class="space-y-3 text-sm text-slate-400">
                <li><a href="about.jsp" class="hover:text-white transition">About Us</a></li>
                <li><a href="#" class="hover:text-white transition">Success Stories</a></li>
                <li><a href="#" class="hover:text-white transition">News & Updates</a></li>
                <li><a href="contact.jsp" class="hover:text-white transition">Contact Us</a></li>
            </ul>
        </div>

        <div>
            <h3 class="text-white font-semibold mb-4">Support</h3>
            <ul class="space-y-3 text-sm text-slate-400">
                <li><a href="#" class="hover:text-white transition">Help Center</a></li>
                <li><a href="#" class="hover:text-white transition">Documentation</a></li>
                <li><a href="#" class="hover:text-white transition">Terms of Service</a></li>
                <li><a href="#" class="hover:text-white transition">Privacy Policy</a></li>
            </ul>
        </div>
    </div>

    <div class="border-t border-white/10">
        <div class="container-wide mx-auto px-5 lg:px-8 py-5 text-xs text-slate-500">
            © 2026 SahakariNet. Built for Nepal's cooperative community.
        </div>
    </div>
</footer>

</body>
</html>
