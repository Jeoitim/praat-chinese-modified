"""Real analysis workflows, portable saves and backed-up input formatting checks."""
import argparse
import math
import hashlib
import json
import re
import subprocess
import tempfile
import uuid
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
def literal(value):return '"'+str(value).replace('"','""')+'"'
def text(path):
    data=path.read_bytes()
    return data.decode('utf-16') if data.startswith((b'\xff\xfe',b'\xfe\xff')) else data.decode('utf-8-sig')

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('executable',type=Path)
    parser.add_argument('--tone',type=Path)
    parser.add_argument('--intonation',type=Path)
    args=parser.parse_args()
    executable=args.executable.resolve()
    runtime=executable.parent
    if runtime.name=='MacOS':runtime=runtime.parent.parent.parent
    data=runtime/'data';data.mkdir(exist_ok=True)
    original_hashes={str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in [args.tone,args.intonation] if p}
    case='regression_'+uuid.uuid4().hex[:8]
    results=[]
    with tempfile.TemporaryDirectory(prefix=case+'_',dir=data) as temporary:
        base=Path(temporary)
        source_tone=base/'字调 中文 空格.txt'
        source_intonation=base/'语调 中文 空格.txt'
        if args.tone:source_tone.write_bytes(args.tone.read_bytes())
        else:source_tone.write_text('\n'.join('\t'.join([str(group)]+[str(120+group*15+point*2+trial) for point in range(9)]+['0.25','样本 名称','0.1','0.35']) for group in range(1,4) for trial in range(3))+'\n',encoding='utf-8')
        if args.intonation:source_intonation.write_bytes(args.intonation.read_bytes())
        else:source_intonation.write_text('\n'.join('\t'.join([str(sentence),str(syllable)]+[str(100+sentence*5+syllable*10+point+trial) for point in range(9)]+['0.2','句子 样本','0.1','0.3']) for sentence in range(1,3) for syllable in range(1,4) for trial in range(2))+'\n',encoding='utf-8')
        input_hashes={p:hashlib.sha256(p.read_bytes()).hexdigest() for p in [source_tone,source_intonation]}
        def run(script,*parameters):
            process=subprocess.run([str(executable),'--utf8','--FULL-TRUST','--no-pref-files','--run',str(script),*map(str,parameters)],cwd=base,capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=60)
            if process.returncode or re.search(r'(?m)^Error:|^Script .*not completed',process.stderr):
                raise AssertionError(f'{script.name}:\n{process.stdout}\n{process.stderr}')
            return process.stdout
        def injected(name,source):
            code=(ROOT/f'assets/legacy/{name}.praat').read_text(encoding='utf-8')
            code=re.sub(r'chooseReadFile\$\s*(?:\([^\n]*\)|:\s*"[^\n]*")',lambda match:literal(source),code)
            script=base/(name+'.praat');script.write_text(code,encoding='utf-8');return script
        row_count=len([line for line in text(source_tone).splitlines() if line.strip()])
        importer=base/'import.praat'
        importer.write_text(f'''Modified read analysis table: {literal(source_tone)}, "tone dot1 dot2 dot3 dot4 dot5 dot6 dot7 dot8 dot9 duration file start end"
rows = Get number of rows
assert rows = {row_count}
assert fileReadable(dataDirectory$ + "/toneIPA.txt")
assert index(preferencesDirectory$, "settings") <> 0
Save as binary file: {literal(base/'roundtrip.Table')}
Remove
Modified read analysis table: {literal(base/'roundtrip.Table')}, ""
rows = Get number of rows
assert rows = {row_count}
''',encoding='utf-8')
        run(importer);results.append('headerless Unicode input and native Table roundtrip')
        for method in ['lgHertz','Hertz']:
            name=case+'_tone_'+method
            run(injected('c',source_tone),'yes','yes',method,'Blue',name,name)
            assert (data/(name+'.xls')).is_file()
            assert (data/(name+('.png' if executable.suffix=='.exe' else '.pdf'))).is_file()
        name=case+'_absolute'
        run(injected('l',source_tone),'yes','yes','lgHertz','Blue',name,name)
        assert (data/(name+'.xls')).is_file()
        results.append('relative/absolute-duration T values with linear/logarithmic modes')
        name=case+'_fluctuation'
        # The form is read before script execution even if historically midway.
        run(injected('r',source_intonation),'yes','1','3','64','Blue','yes',name,name)
        assert (data/(name+'.xls')).is_file()
        assert (data/(name+('.png' if executable.suffix=='.exe' else '.pdf'))).is_file()
        name=case+'_fluctuation_50'
        run(injected('r',source_intonation),'yes','1','3','50','Blue','no',name,name)
        assert (data/(name+'.xls')).is_file()
        results.append('50/64 Hz fluctuation tables and rectangle chart')
        name=case+'_column'
        run(injected('u',source_tone),'2','平均值',name,name,'three_decimal_places','yes','no')
        assert (data/(name+'.xls')).is_file()
        for index in [1,2,3]:assert (data/(name+str(index)+('.png' if executable.suffix=='.exe' else '.pdf'))).is_file()
        results.append('column statistics table and three charts')
        for scale in ['Semitones','Hertz']:
            name=case+'_contour_'+scale
            script=base/'contour.praat'
            script.write_text('Create Sound from formula: "contour", 1, 0, 1, 22050, "0.3*sin(2*pi*200*x)"\n'+f'runScript: {literal(ROOT/"assets/legacy/j.praat")}, 64, 362, 0, 0, "{scale}", "yes", "no", "{name}"\n',encoding='utf-8')
            run(script)
            assert (data/(name+'.tsv')).is_file()
            assert (data/(name+('.png' if executable.suffix=='.exe' else '.pdf'))).is_file()
        # Verify the exported reference numerically, not just file existence.
        for row in text(data/(case+'_contour_Semitones.tsv')).splitlines()[1:]:
            _, hz, st = row.split('\t')
            if hz != '--undefined--':
                assert abs(float(st)-12*math.log2(float(hz)/64)) < 1e-8
        name=case+'_grid'
        script=base/'grid.praat'
        script.write_text('Create Sound from formula: "annotation", 1, 0, 1, 22050, "0.3*sin(2*pi*200*x)"\n'
            +'soundID = selected("Sound")\nTo TextGrid: "tone", ""\nSet interval text: 1, 1, "测试"\n'
            +f'Save as text file: {literal(base/"annotation.TextGrid")}\n'
            +'plusObject: soundID\n'
            +f'runScript: {literal(ROOT/"assets/legacy/j.praat")}, 64, 362, 0, 0, "Hertz", "yes", "yes", "{name}"\n'
            +'selectObject: soundID\n'+f'Save as WAV file: {literal(base/"annotation.wav")}\n',encoding='utf-8')
        run(script)
        assert (data/(name+('.png' if executable.suffix=='.exe' else '.pdf'))).is_file()
        results.append('intonation sound plot in Hz/semitones, numeric reference and TextGrid')
        grid_digest=hashlib.sha256((base/'annotation.TextGrid').read_bytes()).hexdigest()
        for filename, columns, values in [
            ('dc',14,['A']+['200']*9+['0.25','annotation','0.1','0.35']),
            ('db',7,['a','500','1500','2500','annotation','0.2','0.3']),
            ('da',25,['k']+['1']*21+['annotation','0.1','0.35']),
        ]:
            source=base/(filename+'.txt')
            source.write_text('\t'.join(values)+'\n',encoding='utf-8')
            run(injected(filename,source),'wav','no')
            assert (data/'annotation.TextGrid').is_file()
            assert hashlib.sha256((base/'annotation.TextGrid').read_bytes()).hexdigest()==grid_digest
        run(injected('dc',base/'dc.txt'),'wav','yes')
        assert hashlib.sha256((base/'annotation.TextGrid').read_bytes()).hexdigest()!=grid_digest
        results.append('consonant/vowel/tone annotation: portable saves and explicit input-directory saves')
        numeric=base/'statistics.txt'
        numeric.write_text('\n'.join('\t'.join([group]+[str(50+dot*10+trial) for dot in range(25)])
            for group in ['a','b','c'] for trial in range(8))+'\n',encoding='utf-8')
        digest=hashlib.sha256(numeric.read_bytes()).hexdigest()
        for filename in ['af','ar','ay','az','ba','bb','be','cd','cg','d','i']:
            code=(ROOT/f'assets/legacy/{filename}.praat').read_text(encoding='utf-8')
            fields=[];options=None
            for line in code.split('endform')[0].split('form ',1)[1].splitlines()[1:]:
                cells=line.strip().split(maxsplit=2)
                if not cells:continue
                kind=cells[0]
                if kind in ['choice','optionmenu']:
                    options=[];fields.append((kind,int(cells[2].split()[0]),options))
                elif kind in ['button','option'] and options is not None:options.append(' '.join(cells[1:]))
                elif kind in ['boolean','integer','natural','real','positive','sentence','word','text']:
                    value=cells[2] if len(cells)>2 else ''
                    if cells[1].startswith('name_of_'):value=case+'_'+filename+'_'+cells[1]
                    fields.append((kind,value,None))
            params=[]
            for kind,value,options in fields:
                if kind=='choice':params.append(options[value-1])
                elif kind=='boolean':params.append('yes' if str(value).split()[0]=='1' else 'no')
                elif kind in ['integer','natural','real','positive']:params.append(value.split()[0])
                else:params.append(value)
            run(injected(filename,numeric),*params)
        assert hashlib.sha256(numeric.read_bytes()).hexdigest()==digest
        results.append('eleven additional energy/formant/stop/outlier/descriptive-statistics workflows')
        for p,digest in input_hashes.items():
            if hashlib.sha256(p.read_bytes()).hexdigest()!=digest:
                backup=Path(str(p)+'.before-tabs.bak')
                assert backup.is_file() and hashlib.sha256(backup.read_bytes()).hexdigest()==digest,str(p)
        for p,digest in original_hashes.items():assert hashlib.sha256(Path(p).read_bytes()).hexdigest()==digest,p
    print(json.dumps({'passed':results,'user_input_files_unchanged':True,'formatted_copies_backed_up':True,'outputs':str(data)},ensure_ascii=False,indent=2))

if __name__=='__main__':main()
