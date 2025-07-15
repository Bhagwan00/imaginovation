<?php

namespace App\Enums;

enum Status: string
{
    case PENDING = 'Pending';
    case IN_PROGRESS = 'In Progress';
    case DONE = 'Done';
}
