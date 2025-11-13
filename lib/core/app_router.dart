import 'package:go_router/go_router.dart';
import '../features/auth/ui/login_page.dart';
import '../features/complaints/ui/submit_complaint_page.dart';
import '../features/complaints/ui/complaint_list_page.dart'; // ✅ Added 'hide ComplaintStatus'
import '../features/complaints/ui/complaint_detail_page.dart';
import '../features/complaints/ui/upload_proof_page.dart';
import '../features/admin/ui/admin_dashboard_page.dart' hide ComplaintStatus; // ✅ Added 'hide ComplaintStatus'
import 'auth_guard.dart';
import '../features/complaints/data/complaint_model.dart';
import '../features/complaints/data/complaint_status.dart' as status_data; // This import is now the sole provider.
// Note: You have '../features/complaints/data/complaint_model.dart' listed twice, remove one.
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
  builder: (context, state) {
    final id = state.pathParameters['id']!;

    final item = ComplaintItem(
      id: id,
      title: "Demo Complaint",
      description: "This is a placeholder complaint loaded by router.",
      category: "Road / Pothole",
      address: "MG Road, Kochi",
      status: ComplaintStatus.assigned,
      reportedAt: DateTime.now(),
    );

    return ComplaintDetailPage(item: item);
  },
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
