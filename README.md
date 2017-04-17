# winpty.NET
A .NET wrapper for [winpty](https://github.com/rprichard/winpty).

## Build Status
|             | AppVeyor | NuGet |
|-------------|----------|-------|
| **master**  | [![AppVeyor](https://ci.appveyor.com/api/projects/status/g0m338d3u33o9gox/branch/master?svg=true)](https://ci.appveyor.com/project/IntelOrca/winpty-net) | [![NuGet Status](https://img.shields.io/nuget/v/winpty.NET.svg?style=flat)](https://www.nuget.org/packages/winpty.NET/) |

## NuGet

    PM> Install-Package winpty.NET

## Example
```csharp
using System;
using System.IO;
using System.IO.Pipes;
using static winpty.WinPty;

class WinPtyExample
{
    static int Main(string[] args)
    {
        IntPtr handle = IntPtr.Zero;
        IntPtr err = IntPtr.Zero;
        IntPtr cfg = IntPtr.Zero;
        IntPtr spawnCfg = IntPtr.Zero;
        Stream stdin = null;
        Stream stdout = null;
        try
        {
            cfg = winpty_config_new(WINPTY_FLAG_COLOR_ESCAPES, out err);
            winpty_config_set_initial_size(cfg, 80, 32);

            handle = winpty_open(cfg, out err);
            if (err != IntPtr.Zero)
            {
                Console.WriteLine(winpty_error_code(err));
                return 1;
            }

            string exe = @"C:\Windows\System32\cmd.exe";
            string args = "";
            string cwd = @"C:\";
            spawnCfg = winpty_spawn_config_new(WINPTY_SPAWN_FLAG_AUTO_SHUTDOWN, exe, args, cwd, null, out err);
            if (err != IntPtr.Zero)
            {
                Console.WriteLine(winpty_error_code(err));
                return 1;
            }

            stdin = CreatePipe(winpty_conin_name(handle), PipeDirection.Out);
            stdout = CreatePipe(winpty_conout_name(handle), PipeDirection.In);

            if (!winpty_spawn(handle, spawnCfg, out IntPtr process, out IntPtr thread, out int procError, out err))
            {
                Console.WriteLine(winpty_error_code(err));
                return 1;
            }

            // Play with tty streams stdin and stdout...

            return 0;
        }
        finally
        {
            stdin?.Dispose();
            stdout?.Dispose();
            winpty_config_free(cfg);
            winpty_spawn_config_free(spawnCfg);
            winpty_error_free(err);
            winpty_free(handle);
        }
    }

    private Stream CreatePipe(string pipeName, PipeDirection direction)
    {
        string serverName = ".";
        if (pipeName.StartsWith("\\"))
        {
            int slash3 = pipeName.IndexOf('\\', 2);
            if (slash3 != -1)
            {
                serverName = pipeName.Substring(2, slash3 - 2);
            }
            int slash4 = pipeName.IndexOf('\\', slash3 + 1);
            if (slash4 != -1)
            {
                pipeName = pipeName.Substring(slash4 + 1);
            }
        }

        var pipe = new NamedPipeClientStream(serverName, pipeName, direction);
        pipe.Connect();
        return pipe;
    }
}
```

## Copyright
winpty.NET and winpty are both distributed under the MIT license.
