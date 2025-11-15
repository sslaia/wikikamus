import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class CreateNiasNewEntry extends StatefulWidget {
  const CreateNiasNewEntry({super.key, this.title});

  final String? title;

  @override
  State<CreateNiasNewEntry> createState() => _CreateNiasNewEntryState();
}

class _CreateNiasNewEntryState extends State<CreateNiasNewEntry> {
  final GlobalKey<ScaffoldState> _scaffoldFormKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  var _selectedValue = 'Verba';

  @override
  void initState() {
    _titleController.text = widget.title ?? '';
    super.initState();
  }
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldFormKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            "create_new_entry".tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Image.asset(image, height: 150, fit: BoxFit.fitHeight),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _titleController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: "enter_word_here".tr(),
                      labelStyle: TextStyle(fontSize: 10.0),
                      errorText: _titleController.text.isEmpty
                          ? null
                          : "enter_new_word_here".tr(),
                      prefixIcon: Icon(Icons.create),
                      border: OutlineInputBorder(
                        // Optional: adds a border
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "enter_word_please".tr();
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Halö zi faudu',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _selectedValue,
                    items:
                        [
                              'Verba',
                              'Nomina',
                              'Adjektiva',
                              'Adverbia',
                              'Numeralia',
                              'Partikel',
                              'Pronomina',
                              'Preposisi',
                              'Konjungsi',
                              'Intejeksi',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Halö ndroto wehede si faudu';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final String title = _titleController.text.toLowerCase();
                    final String part = _selectedValue;
                    String formulir;
                    if (part == 'Nomina') {
                      formulir = 'preload=Templat:Famörögö wanura nomina';
                    } else if (part == 'Adjektiva') {
                      formulir = 'preload=Templat:Famörögö wanura adjetiva';
                    } else if (part == 'Adverbia') {
                      formulir = 'preload=Templat:Famörögö wanura adverbia';
                    } else if (part == 'Numeralia') {
                      formulir = 'preload=Templat:Famörögö wanura numeralia';
                    } else if (part == 'Partikel') {
                      formulir = 'preload=Templat:Famörögö wanura partikel';
                    } else if (part == 'Pronomina') {
                      formulir = 'preload=Templat:Famörögö wanura pronomina';
                    } else if (part == 'Preposisi') {
                      formulir = 'preload=Templat:Famörögö wanura preposisi';
                    } else if (part == 'Konjungsi') {
                      formulir = 'preload=Templat:Famörögö wanura konjungsi';
                    } else if (part == 'Intejeksi') {
                      formulir = 'preload=Templat:Famörögö wanura interjeksi';
                    } else {
                      formulir = 'preload=Templat:Famörögö wanura verba';
                    }
                    final String url =
                        'https://nia.m.wiktionary.org/wiki/$title?action=edit&section=all&$formulir';
                    if (_formKey.currentState?.validate() ?? false) {
                      // Open the link in an external browser
                      launchUrl(Uri.parse(url));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Color(0xffe9d6ae),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    'create_submit'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
