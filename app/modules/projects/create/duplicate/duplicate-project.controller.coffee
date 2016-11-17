###
# Copyright (C) 2014-2016 Taiga Agile LLC <taiga@taiga.io>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: project.controller.coffee
###

class DuplicateProjectController
    @.$inject = [
        "tgCurrentUserService",
        "tgProjectsService",
        "$tgLocation",
        "$tgNavUrls"
    ]

    constructor: (@currentUserService, @projectsService, @location, @urlservice) ->
        @.projects = @currentUserService.projects.get("all")
        @.user = @currentUserService.getUser()
        @.canCreatePublicProjects = @currentUserService.canCreatePublicProjects()
        @.canCreatePrivateProjects = @currentUserService.canCreatePrivateProjects()
        @.duplicatedProject = {}
        @.duplicatedProject.is_private = false

    getReferenceProject: (project) ->
        @projectsService.getProjectBySlug(project).then (project) =>
            @.referenceProject = project
            members = project.get('members')
            @.getInvitedMembers(members)

    getInvitedMembers: (members) ->
        @.invitedMembers = members
        @.invitedMembers = @.invitedMembers.filter (members) =>
            members.get('id') != @.user.get('id')
        @.setInvitedMembers(@.invitedMembers)

    setInvitedMembers: (members) ->
        @.duplicatedProject.users = members.map (member) =>
            member.get('id')

    onDuplicateProject: () ->
        projectId = @.referenceProject.get('id')
        data = @.duplicatedProject
        @projectsService.duplicate(projectId, data).then (newProject) =>
            console.log newProject
            @location.path(@urlservice.resolve("project", {project: newProject.data.slug}))
            @currentUserService.loadProjects()

angular.module("taigaProjects").controller("DuplicateProjectCtrl", DuplicateProjectController)
