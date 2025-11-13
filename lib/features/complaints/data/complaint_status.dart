// lib/features/complaints/data/complaint_status.dart

/// Public enum for complaint status used across the app.
enum ComplaintStatus {
  unassigned, // For admin/initial tracking
  assigned,
  inProgress,
  resolved,
  escalated, // For admin tracking
}