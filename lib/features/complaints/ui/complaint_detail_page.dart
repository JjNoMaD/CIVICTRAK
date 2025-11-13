// lib/features/complaints/ui/complaint_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'complaint_list_page.dart'; // contains _ComplaintItem and ComplaintStatus enums


class ComplaintDetailPage extends StatefulWidget {
  final ComplaintItem item;
  const ComplaintDetailPage({super.key, required this.item});

  @override
  State<ComplaintDetailPage> createState() => _ComplaintDetailPageState();
}

class _ComplaintDetailPageState extends State<ComplaintDetailPage> {
  late ComplaintItem _item;
  bool _saving = false;
  File? _proofFile;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    if (_item.proofImagePath != null) _proofFile = File(_item.proofImagePath!);
  }

  Future<void> _pickProof(ImageSource src) async {
    final x = await ImagePicker().pickImage(source: src, imageQuality: 80);
    if (x != null) {
      setState(() => _proofFile = File(x.path));
    }
  }

  /// Only allow upload when status is InProgress or Resolved
  bool get _canUploadProof =>
      _item.status == ComplaintStatus.inProgress || _item.status == ComplaintStatus.resolved;

  /// Save locally and return updated item to caller
  Future<void> _saveAndReturn() async {
    if (_item.status == ComplaintStatus.resolved && _proofFile == null) {
      // encourage proof for resolved but not mandatory — optional rule depending on your policy
      final ok = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('No proof attached'),
              content: const Text(
                  'You marked this complaint as Resolved but did not attach proof. Continue anyway?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Continue')),
              ],
            ),
          ) ??
          false;
      if (!ok) return;
    }

    setState(() => _saving = true);

    // TODO: replace below with API call to persist change + upload file to backend
    await Future.delayed(const Duration(milliseconds: 600));

    // update the local copy with potential proof path (we'll store local path for demo)
    final updated = _item.copyWith(proofImagePath: _proofFile?.path);

    if (!mounted) return;
    setState(() => _saving = false);

    // return updated item
    Navigator.pop(context, updated);
  }

  Widget _statusDropdown() {
    return DropdownButtonFormField<ComplaintStatus>(
      value: _item.status,
      items: ComplaintStatus.values
          .map((s) => DropdownMenuItem(
                value: s,
                child: Text(
                  s == ComplaintStatus.assigned
                      ? 'Assigned'
                      : s == ComplaintStatus.inProgress
                          ? 'In Progress'
                          : 'Resolved',
                ),
              ))
          .toList(),
      onChanged: (v) {
        if (v == null) return;
        // Prevent changing resolved -> other (optional)
        if (_item.status == ComplaintStatus.resolved && v != ComplaintStatus.resolved) {
          // if you want to restrict updates on already resolved complaints:
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Cannot change status of a resolved complaint.')));
          return;
        }
        setState(() => _item.status = v);
      },
      decoration: const InputDecoration(labelText: 'Status'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ID: ${_item.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(_item.category, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Text(_item.description),
          const SizedBox(height: 12),
          Text('Address: ${_item.address}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 18),

          // Status selector
          _statusDropdown(),
          const SizedBox(height: 16),

          // Proof image (if selected)
          if (_proofFile != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Proof image', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_proofFile!, height: 180, fit: BoxFit.cover)),
                const SizedBox(height: 12),
              ],
            ),

          // Upload proof controls (only enabled when InProgress or Resolved)
          Row(children: [
            FilledButton.icon(
              onPressed: _canUploadProof
                  ? () async {
                      final choice = await showModalBottomSheet<ImageSource>(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Wrap(children: [
                            ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Take photo'),
                                onTap: () => Navigator.pop(context, ImageSource.camera)),
                            ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Choose from gallery'),
                                onTap: () => Navigator.pop(context, ImageSource.gallery)),
                          ]),
                        ),
                      );
                      if (choice != null) _pickProof(choice);
                    }
                  : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Upload Proof'),
            ),
            const SizedBox(width: 12),
            if (!_canUploadProof)
              const Flexible(child: Text('Attach proof only when status is In Progress or Resolved', style: TextStyle(color: Colors.black54))),
          ]),

          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _saveAndReturn,
              child: _saving
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Save updates')),
            ),
          ),
        ]),
      ),
    );
  }
}
