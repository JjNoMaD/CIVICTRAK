import 'package:go_router/go_router.dart';
import '../features/auth/ui/login_page.dart';
import '../features/complaints/ui/submit_complaint_page.dart';
import '../features/complaints/ui/complaint_list_page.dart';
import '../features/complaints/ui/complaint_detail_page.dart';
import '../features/complaints/ui/upload_proof_page.dart';
import '../features/admin/ui/admin_dashboard_page.dart';
import 'auth_guard.dart';

GoRouter buildRouter() => GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/citizen/submit',
      builder: (context, state) => const SubmitComplaintPage(),
      redirect: authGuardCitizen,
    ),
    GoRoute(
      path: '/list',
      builder: (context, state) => const ComplaintListPage(),
      redirect: authGuardAny,
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) =>
          ComplaintDetailPage(id: state.pathParameters['id']!),
      redirect: authGuardAny,
    ),
    GoRoute(
      path: '/staff/upload/:id',
      builder: (context, state) =>
          UploadProofPage(id: state.pathParameters['id']!),
      redirect: authGuardStaff,
    ),
   
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardPage(),
      redirect: authGuardAdmin,
    ),
  ],
);
