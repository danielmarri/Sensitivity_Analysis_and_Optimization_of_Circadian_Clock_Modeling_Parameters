function AMIGO_writeHtmlTableStyle(fid)
% write the style-related header in the html header part.
fprintf(fid,'<style type="text/css">\n');
fprintf(fid,'.tftable {font-size:12px;color:#333333;width:100%%;border-width: 1px;border-color: #729ea5;border-collapse: collapse;}\n');
fprintf(fid,'.tftable th {font-size:12px;background-color:#acc8cc;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;text-align:left;}\n');
fprintf(fid,'.tftable tr {background-color:#d4e3e5;}\n');
fprintf(fid,'.tftable td {font-size:12px;border-width: 1px;padding: 8px;border-style: solid;border-color: #729ea5;}\n');
fprintf(fid,'.tftable tr:hover {background-color:#ffffff;}\n');
fprintf(fid,'</style>\n');