<?php

namespace App\Http\Controllers\Api\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\EventData;

class EventDataController extends Controller
{
    public function index() {
        $data = EventData::latest()->cursorPaginate(10);

        return response()->json($data);
    }
}
