/*
* Copyright (c) 2020 Taqmeel Zubeir
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Taqmeel Zubeir <taqmeelzubeir.dev@gmail.com>
*/

public class Alohomora.Preferences: Gtk.Dialog {
    public Alohomora.SecretManager secret {get; construct;}

    private Settings settings;
    private Gtk.Grid grid;
    private Gtk.Label general_section_label;
    private Gtk.Label pass_section_label;
    private Gtk.Label sort_label;
    private Gtk.ComboBoxText sort;
    private Gtk.Label copy_label;
    private Gtk.Switch copy;
    private Gtk.Separator separator;
    private Gtk.Label pass_length_label;
    private Gtk.SpinButton pass_length;
    private Gtk.Label include_special_label;
    private Gtk.Switch include_special;
    private Gtk.Label include_digit_label;
    private Gtk.Switch include_digit;

    public Preferences (Alohomora.Window app_window, Alohomora.SecretManager secret_manager) {
        Object (
            title: _("Preferences"),
            transient_for: app_window,
            deletable: false,
            resizable: false,
            modal: true,
            border_width: 10,
            secret: secret_manager
        );
    }

    construct {
        settings = new Settings ("com.github.z0o0p.alohomora");

        general_section_label = new Gtk.Label (_("General"));
        general_section_label.get_style_context ().add_class ("header-text");
        general_section_label.halign = Gtk.Align.START;

        sort_label = new Gtk.Label (_("Sort Secrets By: "));
        sort_label.halign = Gtk.Align.END;
        sort = new Gtk.ComboBoxText ();
        sort.insert_text (0, _("Ascending Order"));
        sort.insert_text (1, _("Descending Order"));
        sort.set_active ((settings.get_boolean ("sort-ascending")) ? 0 : 1);

        copy_label = new Gtk.Label (_("Copy New Password After Adding: "));
        copy_label.halign = Gtk.Align.END;
        copy = new Gtk.Switch ();
        copy.halign = Gtk.Align.START;
        copy.valign = Gtk.Align.CENTER;
        copy.set_active (settings.get_boolean ("copy-new-pass"));

        separator = new Gtk.Separator (Gtk.Orientation.HORIZONTAL);
        separator.margin = 5;

        pass_section_label = new Gtk.Label (_("Password Generator"));
        pass_section_label.get_style_context ().add_class ("header-text");
        pass_section_label.halign = Gtk.Align.START;

        include_digit_label = new Gtk.Label (_("Include Digits: "));
        include_digit_label.halign = Gtk.Align.END;
        include_digit = new Gtk.Switch ();
        include_digit.halign = Gtk.Align.START;
        include_digit.valign = Gtk.Align.CENTER;
        include_digit.set_active (settings.get_boolean ("include-digit"));

        include_special_label = new Gtk.Label (_("Include Special Characters: "));
        include_special_label.halign = Gtk.Align.END;
        include_special = new Gtk.Switch ();
        include_special.halign = Gtk.Align.START;
        include_special.valign = Gtk.Align.CENTER;
        include_special.set_active (settings.get_boolean ("include-special"));

        pass_length_label = new Gtk.Label (_("Generated Password Length: "));
        pass_length_label.halign = Gtk.Align.END;
        pass_length = new Gtk.SpinButton.with_range (8, 24, 1);
        pass_length.set_value (settings.get_int ("gen-pass-length"));

        grid = new Gtk.Grid ();
        grid.row_spacing = 5;
        grid.column_spacing = 5;
        grid.halign = Gtk.Align.CENTER;
        grid.margin = 5;
        grid.attach (general_section_label, 0, 0, 2, 1);
        grid.attach (sort_label,            0, 1, 1, 1);
        grid.attach (sort,                  1, 1, 1, 1);
        grid.attach (copy_label,            0, 2, 1, 1);
        grid.attach (copy,                  1, 2, 1, 1);
        grid.attach (separator,             0, 3, 2, 1);
        grid.attach (pass_section_label,    0, 4, 2, 1);
        grid.attach (pass_length_label,     0, 5, 1, 1);
        grid.attach (pass_length,           1, 5, 1, 1);
        grid.attach (include_special_label, 0, 6, 1, 1);
        grid.attach (include_special,       1, 6, 1, 1);
        grid.attach (include_digit_label,   0, 7, 1, 1);
        grid.attach (include_digit,         1, 7, 1, 1);

        var dialog_content = get_content_area ();
        dialog_content.spacing = 5;
        dialog_content.pack_start (grid);
        dialog_content.show_all ();

        add_button (_("Close"), Gtk.ResponseType.CLOSE);
        var add = add_button (_("Apply"), Gtk.ResponseType.APPLY);
        add.get_style_context ().add_class ("suggested-button");

        response.connect (id => {
            if (id == Gtk.ResponseType.APPLY) {
                settings.set_boolean ("sort-ascending", (sort.active == 0));
                settings.set_boolean ("copy-new-pass", copy.active);
                settings.set_int ("gen-pass-length", (int)pass_length.value);
                settings.set_boolean ("include-special", include_special.active);
                settings.set_boolean ("include-digit", include_digit.active);
                secret.ordering_changed ();
            }
            destroy ();
        });
    }
}
