import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/complaint_repository.dart';

class UploadProofPage extends StatefulWidget {
  final String id;
  const UploadProofPage({super.key, required this.id});
  @override State<UploadProofPage> createState()=>_UploadProofPageState();
}
class _UploadProofPageState extends State<UploadProofPage>{
  File? img;
  @override Widget build(BuildContext ctx)=>Scaffold(
    appBar: AppBar(title: const Text('Upload Proof')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children:[
        OutlinedButton(onPressed: () async {
          final x=await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality:75);
          if(x!=null) setState(()=> img = File(x.path));
        }, child: const Text('Choose Photo')),
        const SizedBox(height:12),
        FilledButton(onPressed: img==null?null:() async {
          await ComplaintRepository().uploadProof(widget.id, img!);
          if(mounted) Navigator.pop(ctx);
        }, child: const Text('Upload')),
      ]),
    ),
  );
}
