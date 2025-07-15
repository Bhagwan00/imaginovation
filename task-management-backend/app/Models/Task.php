<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    protected $fillable = [
        'title',
        'description',
        'status',
        'due_date',
        'assigned_to',
        'priority',
        'user_id',
    ];

    /**
     * Get all of the comments for the Task
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasMany
     */
    public function comments()
    {
        return $this->hasMany(Comment::class, 'task_id', 'id');
    }

    /**
     * Get the user that owns the Task
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }

    /**
     * Get the assigned_user that owns the Task
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function assigned_user()
    {
        return $this->belongsTo(User::class, 'assigned_to', 'id');
    }
}
